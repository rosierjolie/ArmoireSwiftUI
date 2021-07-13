//
// FirebaseManager.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

final class FirebaseManager {
    static let shared = FirebaseManager()

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    private init() {}

    // MARK: - Auth methods

    func uploadAvatarImage(for image: UIImage, name: String, completed: @escaping (Result<URL?, AMError>) -> Void) {
        let storageRef = storage.reference()
        let avatarImageRef = storageRef.child("avatars/\(name)-avatar.jpg")

        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return completed(.failure(.invalidImage))
        }

        let dataTask = avatarImageRef.putData(data, metadata: nil) { metadata, error in
            avatarImageRef.downloadURL { url, error in
                if error != nil {
                    return completed(.failure(.unableToComplete))
                }

                // TODO: Figure out why downloadUrl comes back as nil even on successful upload
                guard let downloadUrl = url else { return }

                return completed(.success(downloadUrl))
            }
        }

        dataTask.resume()
    }

    func updateUsername(with username: String, errorHandler: @escaping (Error?) -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        var responseError: Error?

        changeRequest?.displayName = username

        changeRequest?.commitChanges { error in
            responseError = error
        }

        errorHandler(responseError)
    }

    // MARK: - Clothes collection

    func addClothing(with clothing: Clothing, image: UIImage, folderId: String, completed: @escaping (Result<Clothing, AMError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let folderRef = db.collection("folders").document(folderId)
        let clothesRef = db.collection("clothes")
        let storageRef = storage.reference()

        folderRef.updateData([
            "itemCount": FieldValue.increment(Int64(1))
        ])

        let clothingImageRef = storageRef.child("images/\(clothing.name.blobCase.lowercased()).jpg")

        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return completed(.failure(.invalidImage))
        }

        let uploadTask = clothingImageRef.putData(data, metadata: nil) { metadata, error in
            clothingImageRef.downloadURL { url, error in
                if error != nil {
                    return completed(.failure(.unableToComplete))
                }

                guard let downloadUrl = url else {
                    return completed(.failure(.invalidUrl))
                }

                var newClothing = Clothing(
                    imageUrl: downloadUrl,
                    name: clothing.name,
                    brand: clothing.brand,
                    quantity: clothing.quantity,
                    color: clothing.color,
                    isFavorite: clothing.isFavorite,
                    description: clothing.description ?? nil,
                    size: clothing.size ?? nil,
                    material: clothing.material ?? nil,
                    url: clothing.url ?? nil,
                    dateCreated: clothing.dateCreated,
                    dateUpdated: clothing.dateUpdated,
                    folder: folderRef,
                    folderId: folderId,
                    userId: uid
                )

                do {
                    let document = try clothesRef.addDocument(from: newClothing)
                    newClothing.id = document.documentID
                    completed(.success(newClothing))
                } catch {
                    completed(.failure(.invalidData))
                }
            }
        }

        uploadTask.resume()
    }

    func fetchAllClothes(completed: @escaping (Result<[String: [Clothing]], AMError>) -> Void) {
        fetchFolders { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let fetchedFolders): self.iterateOnFetchedFolders(folders: fetchedFolders, completed: completed)
            case .failure(let error): completed(.failure(error))
            }
        }
    }

    func iterateOnFetchedFolders(folders: [Folder], completed: @escaping (Result<[String: [Clothing]], AMError>) -> Void) {
        let sortedFolders = folders.sorted { $0.title > $1.title }

        for folder in sortedFolders {
            guard let folderId = folder.id else { continue }

            self.fetchClothes(for: folderId) { result in
                switch result {
                case .success(let clothes): completed(.success([folder.title: clothes]))
                case .failure(let error): completed(.failure(error))
                }
            }
        }
    }

    func fetchClothes(for folderId: String, completed: @escaping (Result<[Clothing], AMError>) -> Void) {
        let folderRef = db.collection("folders").document(folderId)
        let clothingQuery = db.collection("clothes").whereField("folder", isEqualTo: folderRef)

        clothingQuery.getDocuments { querySnapshot, error in
            if error != nil {
                return completed(.failure(.unableToComplete))
            }

            guard let documents = querySnapshot?.documents else {
                fatalError("Something went wrong.")
            }

            var clothes = documents.compactMap { document in
                return try? document.data(as: Clothing.self)
            }

            clothes = clothes.sorted { firstItem, secondItem in
                if firstItem.isFavorite == secondItem.isFavorite {
                    return firstItem.name < secondItem.name
                }

                return firstItem.isFavorite && !secondItem.isFavorite
            }

            completed(.success(clothes))
        }
    }

    func favoriteClothing(_ clothing: Clothing) {
        guard let id = clothing.id else { return }
        let clothingRef = db.collection("clothes").document(id)
        clothingRef.updateData(["isFavorite": clothing.isFavorite])
    }

    func updateClothing(_ clothing: Clothing, image: UIImage? = nil, completed: @escaping (Result<Clothing, AMError>) -> Void) {
        guard let id = clothing.id else { return }
        let clothingRef = db.collection("clothes").document(id)
        let storageRef = storage.reference()

        let clothingImageRef = storageRef.child("images/\(clothing.name.blobCase.lowercased()).jpg")

        guard let dateUpdated = clothing.dateUpdated else { return }

        clothingRef.updateData([
            "name": clothing.name,
            "brand": clothing.brand,
            "quantity": clothing.quantity,
            "color": clothing.color,
            "isFavorite": clothing.isFavorite,
            "dateCreated": clothing.dateCreated,
            "dateUpdated": dateUpdated
        ])

        if let description = clothing.description {
            clothingRef.updateData(["description": description])
        } else {
            clothingRef.updateData(["description": FieldValue.delete()])
        }

        if let size = clothing.size {
            clothingRef.updateData(["size": size])
        } else {
            clothingRef.updateData(["size": FieldValue.delete()])
        }

        if let material = clothing.material {
            clothingRef.updateData(["material": material])
        } else {
            clothingRef.updateData(["material": FieldValue.delete()])
        }

        if let url = clothing.url {
            clothingRef.updateData(["url": url])
        } else {
            clothingRef.updateData(["url": FieldValue.delete()])
        }

        var updatedClothing = clothing
        updatedClothing.dateUpdated = dateUpdated

        if let image = image {
            guard let data = image.jpegData(compressionQuality: 0.8) else {
                return completed(.failure(.invalidImage))
            }

            let uploadTask = clothingImageRef.putData(data, metadata: nil) { metadata, error in
                clothingImageRef.downloadURL { url, error in
                    if error != nil {
                        return completed(.failure(.unableToComplete))
                    }

                    guard let downloadUrl = url else {
                        return completed(.failure(.invalidUrl))
                    }

                    clothingRef.updateData(["imageUrl": downloadUrl.absoluteString])
                    updatedClothing.imageUrl = downloadUrl
                }
            }

            uploadTask.resume()
        }

        completed(.success(updatedClothing))
    }

    func deleteClothing(_ clothing: Clothing, folderId: String, errorHandler: @escaping (AMError) -> Void) {
        guard let id = clothing.id else { return }
        let folderRef = db.collection("folders").document(folderId)

        folderRef.updateData([
            "itemCount": FieldValue.increment(Int64(-1))
        ])

        deleteClothingImage(for: clothing, errorHandler: errorHandler)

        db.collection("clothes").document(id).delete { error in
            if error != nil {
                return errorHandler(.failedToDeleteClothing)
            }
        }
    }

    func deleteClothingImage(for clothing: Clothing, errorHandler: @escaping (AMError) -> Void) {
        let storageRef = storage.reference()
        let clothingImageRef = storageRef.child("images/\(clothing.name.blobCase.lowercased()).jpg")

        // Deletes the image from firebase storage associated to the clothing item
        clothingImageRef.delete { error in
            if error != nil {
                return errorHandler(.failedToDeleteImage)
            }
        }
    }

    // MARK: - Folders collection

    func createFolder(with folder: Folder, completed: @escaping (Result<Folder, AMError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let foldersRef = db.collection("folders")

        var newFolder = Folder(
            title: folder.title,
            description: folder.description ?? nil,
            isFavorite: folder.isFavorite,
            itemCount: folder.itemCount,
            userId: uid
        )

        do {
            let document = try foldersRef.addDocument(from: newFolder)
            newFolder.id = document.documentID
            completed(.success(newFolder))
        } catch {
            completed(.failure(.invalidData))
        }
    }

    func fetchFolders(completed: @escaping (Result<[Folder], AMError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let folderQuery = db.collection("folders").whereField("userId", isEqualTo: uid)

        folderQuery.getDocuments { querySnapshot, error in
            if error != nil {
                return completed(.failure(.unableToComplete))
            }

            guard let documents = querySnapshot?.documents else {
                return completed(.failure(.nonexistentDocument))
            }

            let folders = documents.compactMap { document in
                return try? document.data(as: Folder.self)
            }

            completed(.success(folders))
        }
    }

    func favoriteFolder(_ folder: Folder) {
        guard let folderId = folder.id else { return }
        let clothingRef = db.collection("folders").document(folderId)
        clothingRef.updateData(["isFavorite": folder.isFavorite])
    }

    func updateFolder(_ folder: Folder, completed: ((Folder) -> Void)? = nil) {
        guard let folderId = folder.id else { return }
        let folderRef = db.collection("folders").document(folderId)

        if let description = folder.description {
            folderRef.updateData([
                "title": folder.title,
                "description": description,
                "isFavorite": folder.isFavorite,
                "itemCount": folder.itemCount
            ])
        } else {
            folderRef.updateData([
                "title": folder.title,
                "description": FieldValue.delete(),
                "isFavorite": folder.isFavorite,
                "itemCount": folder.itemCount
            ])
        }

        completed?(folder)
    }

    func deleteFolder(_ folder: Folder, errorHandler: @escaping (AMError) ->Void) {
        guard let folderId = folder.id else { return }

        // Deletes all clothes along with their images in storage for the given folder
        fetchClothes(for: folderId) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let clothes): self.deleteClothesForFolder(clothes, folderId: folderId, errorHandler: errorHandler)
            case .failure(let error): errorHandler(error)
            }
        }

        db.collection("folders").document(folderId).delete { error in
            if error != nil {
                return errorHandler(.failedToDeleteFolder)
            }
        }
    }

    private func deleteClothesForFolder(_ clothes: [Clothing], folderId: String, errorHandler: @escaping (AMError) -> Void) {
        for clothing in clothes {
            guard let id = clothing.id else { break }
            let clothingRef = db.collection("clothes").document(id)

            clothingRef.getDocument { document, error in
                if error != nil {
                    return errorHandler(.unableToComplete)
                }

                guard let document = document, document.exists else {
                    return errorHandler(.nonexistentDocument)
                }

                do {
                    guard let clothing = try document.data(as: Clothing.self) else { return }

                    self.deleteClothing(clothing, folderId: folderId) { error in
                        errorHandler(.failedToDeleteClothing)
                    }
                } catch {
                    return errorHandler(.invalidData)
                }
            }
        }
    }

    // MARK: - Runways collection

    func createRunway(with runway: Runway, completed: @escaping (Result<Runway, AMError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let runwaysRef = db.collection("runways")

        var newRunway = Runway(
            title: runway.title,
            isFavorite: runway.isFavorite,
            isSharing: runway.isSharing,
            dateCreated: runway.dateCreated,
            userId: uid
        )

        do {
            let document = try runwaysRef.addDocument(from: newRunway)
            newRunway.id = document.documentID
            completed(.success(newRunway))
        } catch {
            completed(.failure(.invalidData))
        }
    }

    func fetchRunways(completed: @escaping (Result<[Runway], AMError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let runwayQuery = db.collection("runways").whereField("userId", isEqualTo: uid)

        runwayQuery.getDocuments { querySnapshot, error in
            if error != nil {
                return completed(.failure(.unableToComplete))
            }

            guard let documents = querySnapshot?.documents else {
                return completed(.failure(.nonexistentDocument))
            }

            let runways = documents.compactMap { document in
                return try? document.data(as: Runway.self)
            }

            completed(.success(runways))
        }
    }

    func updateRunway(_ runway: Runway, completed: @escaping (Result<Runway, AMError>) -> Void) {
        guard let id = runway.id else { return }
        let runwayRef = db.collection("runways").document(id)
        runwayRef.updateData(["title": runway.title, "isFavorite": runway.isFavorite])
    }

    func updateRunwayCanvas(_ runway: Runway, itemNodes: [ItemNode], errorHandler: @escaping (AMError) -> Void) {
        guard let id = runway.id else { return }
        let runwayRef = db.collection("runways").document(id)
        let storageRef = storage.reference()

        let runwayCanvasRef = storageRef.child("runways/\(id.blobCase).json")

        do {
            let jsonData = try JSONEncoder().encode(itemNodes)

            let uploadTask = runwayCanvasRef.putData(jsonData, metadata: nil) { metadata, error in
                runwayCanvasRef.downloadURL { url, error in
                    if error != nil {
                        return errorHandler(.unableToComplete)
                    }

                    guard let downloadUrl = url else {
                        return errorHandler(.invalidUrl)
                    }

                    runwayRef.updateData([
                        "dataUrl": downloadUrl.absoluteString,
                        "dateUpdated": Date()
                    ])
                }
            }

            uploadTask.resume()
        } catch {
            errorHandler(.invalidData)
        }
    }

    func deleteRunway(_ runway: Runway, errorHandler: @escaping (AMError) -> Void) {
        guard let runwayId = runway.id else { return }

        if runway.dataUrl != nil {
            deleteRunwayData(for: runwayId, errorHandler: errorHandler)
        }

        db.collection("runways").document(runwayId).delete { error in
            if error != nil {
                return errorHandler(.failedToDeleteRunway)
            }
        }
    }

    func deleteRunwayData(for runwayId: String, errorHandler: @escaping (AMError) -> Void) {
        let storageRef = storage.reference()
        let runwayCanvasRef = storageRef.child("runways/\(runwayId.blobCase).json")

        // Deletes the image from firebase storage associated to the clothing item
        runwayCanvasRef.delete { error in
            if error != nil {
                return errorHandler(.failedToDeleteCanvas)
            }
        }
    }
}
