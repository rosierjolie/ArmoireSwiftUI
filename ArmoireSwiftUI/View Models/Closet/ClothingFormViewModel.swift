//
// ClothingFormViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

final class ClothingFormViewModel: ObservableObject {
    @Published var sourceTypeItem: SourceTypeItem?
    @Published var selectedImage: UIImage?

    @Published var name = ""
    @Published var brand = ""
    @Published var quantity = 0
    @Published var color: Color = .accentColor
    @Published var markedAsFavorite = false

    @Published var description = ""
    @Published var size = ""
    @Published var material = ""
    @Published var url = ""

    @Published var alertItem: AlertItem?

    var folderId = ""

    private var selectedClothing: Clothing?

    init(folderId: String) {
        self.folderId = folderId
    }

    init(clothing: Clothing? = nil) {
        self.setPreviousValues(clothing: clothing)
    }

    func setPreviousValues(clothing: Clothing?) {
        guard let clothing = clothing else { return }
        selectedClothing = clothing

        do {
            // Grabs the image data instance
            if let imageUrl = clothing.imageUrl {
                let imageData = try Data(contentsOf: imageUrl)
                selectedImage = UIImage(data: imageData)
            }
        } catch {
            selectedImage = nil
        }

        // Required fields
        name = clothing.name
        brand = clothing.brand
        quantity = clothing.quantity
        color = Color(hex: clothing.color)
        markedAsFavorite = clothing.isFavorite

        // Optional fields
        description = clothing.description ?? ""
        size = clothing.size ?? ""
        material = clothing.material ?? ""
        url = clothing.url ?? ""
    }

    func submitClothing(completed: @escaping (_ clothing: Clothing) -> Void) {
        guard let image = selectedImage else {
            return alertItem = .init(errorMessage: "An image is required when adding a clothing item. Please add an image and try again.")
        }

        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Shows an error if a name was not entered
            return alertItem = .init(errorMessage: "A title is required when adding a clothing item. Please enter a title and try again.")
        } else if brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Shows an error if a brand was not entered
            return alertItem = .init(errorMessage: "A brand is required when adding a clothing item. Please enter a brand and try again.")
        } else {
            if let clothing = selectedClothing {
                FirebaseManager.shared.deleteClothingImage(for: clothing) { [weak self] error in
                    guard let self = self else { return }
                    return self.alertItem = .init(errorMessage: error.localizedDescription)
                }

                let updatedClothing = Clothing(
                    id: clothing.id,
                    name: name,
                    brand: brand,
                    quantity: quantity,
                    color: color.hexDescription(includeAlpha: true),
                    isFavorite: markedAsFavorite,
                    description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description,
                    size: size.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : size,
                    material: material.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : material,
                    url: url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : url,
                    dateCreated: clothing.dateCreated,
                    dateUpdated: Date(),
                    folder: clothing.folder,
                    folderId: clothing.folderId
                )

                FirebaseManager.shared.updateClothing(updatedClothing, image: image) { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case .success(let clothing): completed(clothing)
                    case .failure(let error): self.alertItem = .init(errorMessage: error.localizedDescription)
                    }
                }
            } else {
                let newClothing = Clothing(
                    name: name,
                    brand: brand,
                    quantity: quantity,
                    color: color.hexDescription(includeAlpha: true),
                    isFavorite: markedAsFavorite,
                    description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description,
                    size: size.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : size,
                    material: material.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : material,
                    url: url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : url,
                    folderId: folderId
                )

                // TODO: Figure out how to get the folderId without having to prop drill to nuclear levels
                FirebaseManager.shared.addClothing(with: newClothing, image: image, folderId: folderId) { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case .success(let clothing): completed(clothing)
                    case .failure(let error): self.alertItem = .init(errorMessage: error.localizedDescription)
                    }
                }
            }
        }
    }
}
