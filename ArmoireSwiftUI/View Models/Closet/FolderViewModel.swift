//
// FolderViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Foundation

final class FolderViewModel: ObservableObject {
    @Published var fetchedClothes: [Clothing] = []
    @Published var searchText = ""

    @Published var isClothingFormVisible = false
    @Published var isFolderFormVisible = false

    @Published var alertItem: AlertItem?
    @Published var isLoading = false

    var folder: Folder

    var clothes: [Clothing] {
        let filteredFetchedClothes = fetchedClothes.filter {
            searchText.isEmpty ? true :
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.brand.lowercased().contains(searchText.lowercased())
        }

        return searchText.isEmpty ? fetchedClothes : filteredFetchedClothes
    }

    init(folder: Folder) {
        self.folder = folder
        fetchClothes(withLoading: true)
    }

    func fetchClothes() {
        fetchClothes(withLoading: false)
    }

    func fetchClothes(withLoading: Bool = false) {
        guard let folderId = folder.id else { return }
        if withLoading { isLoading = true }

        FirebaseManager.shared.fetchClothes(for: folderId) { [weak self] result in
            guard let self = self else { return }
            if withLoading { self.isLoading = false }

            switch result {
            case .success(let clothes): self.updateClothes(with: clothes)
            case .failure(let error): self.alertItem = .init(errorMessage: error.localizedDescription)
            }
        }
    }

    // MARK: - Swipe action methods

    func toggleFavorite(for selectedClothing: Clothing) {
        for (index, clothing) in fetchedClothes.enumerated() {
            if clothing.id == selectedClothing.id {
                var updatedClothing = clothing
                updatedClothing.isFavorite.toggle()

                fetchedClothes.remove(at: index)
                fetchedClothes.append(updatedClothing)
                sortFetchedClothes()

                FirebaseManager.shared.favoriteClothing(updatedClothing)
            }
        }
    }

    func delete(_ selectedClothing: Clothing) {
        guard let folderId = folder.id else { return }

        for (index, clothing) in fetchedClothes.enumerated() {
            if clothing.id == selectedClothing.id {
                FirebaseManager.shared.deleteClothing(clothing, folderId: folderId) { [weak self] error in
                    guard let self = self else { return }
                    self.alertItem = AlertItem(errorMessage: error.localizedDescription)
                    return
                }

                fetchedClothes.remove(at: index)
            }
        }
    }

    // MARK: - Private methods

    private func sortFetchedClothes() {
        fetchedClothes = fetchedClothes.sorted { firstItem, secondItem in
            if firstItem.isFavorite == secondItem.isFavorite {
                return firstItem.name < secondItem.name
            }

            return firstItem.isFavorite && !secondItem.isFavorite
        }
    }

    private func updateClothes(with clothes: [Clothing]) {
        fetchedClothes = clothes
        sortFetchedClothes()
    }
}
