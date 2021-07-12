//
// ClosetViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Foundation

final class ClosetViewModel: ObservableObject {
    @Published var fetchedFolders: [Folder] = []
    @Published var searchText = ""

    @Published var isFolderFormVisible = false

    @Published var alertItem: AlertItem?
    @Published var isLoading = false

    var folders: [Folder] {
        let filteredFetchedFolders = fetchedFolders.filter {
            searchText.isEmpty ? true : $0.title.lowercased().contains(searchText.lowercased())
        }

        return searchText.isEmpty ? fetchedFolders : filteredFetchedFolders
    }

    init() {
        fetchFolders(withLoading: true)
    }

    func fetchFolders() {
        fetchFolders(withLoading: false)
    }

    func fetchFolders(withLoading: Bool = false) {
        if withLoading { isLoading = true }

        FirebaseManager.shared.fetchFolders { [weak self] result in
            guard let self = self else { return }
            if withLoading { self.isLoading = false }

            switch result {
            case .success(let folders): self.updateFolders(with: folders)
            case .failure(let error): self.alertItem = AlertItem(errorMessage: error.localizedDescription)
            }
        }
    }

    // MARK: - Swipe action methods

    func toggleFavorite(for selectedFolder: Folder) {
        for (index, folder) in fetchedFolders.enumerated() {
            if folder.id == selectedFolder.id {
                var updatedFolder = folder
                updatedFolder.isFavorite.toggle()

                fetchedFolders.remove(at: index)
                fetchedFolders.append(updatedFolder)
                sortFetchedFolders()

                FirebaseManager.shared.updateFolder(updatedFolder)
            }
        }
    }

    func delete(_ selectedFolder: Folder) {
        for (index, folder) in fetchedFolders.enumerated() {
            if folder.id == selectedFolder.id {
                FirebaseManager.shared.deleteFolder(folder) { [weak self] error in
                    guard let self = self else { return }
                    self.alertItem = AlertItem(errorMessage: error.localizedDescription)
                }

                fetchedFolders.remove(at: index)
            }
        }
    }

    // MARK: - Private methods

    private func sortFetchedFolders() {
        fetchedFolders = fetchedFolders.sorted { firstItem, secondItem in
            if firstItem.isFavorite == secondItem.isFavorite {
                return firstItem.title < secondItem.title
            }

            return firstItem.isFavorite && !secondItem.isFavorite
        }
    }

    private func updateFolders(with folders: [Folder]) {
        fetchedFolders = folders
        sortFetchedFolders()
    }
}
