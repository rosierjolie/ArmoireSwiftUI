//
// ClosetViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Foundation

final class ClosetViewModel: ObservableObject {
    @Published var folders: [Folder] = []
    @Published var searchText = ""

    @Published var alertItem: AlertItem?
    @Published var isLoading = false

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
            case .success(let folders): self.folders = folders.sorted { $0.title < $1.title }
            case .failure(let error): self.alertItem = AlertItem(errorMessage: error.localizedDescription)
            }
        }
    }

    func toggleFavorite(for selectedFolder: Folder) {
        for (index, folder) in folders.enumerated() {
            if folder.id == selectedFolder.id {
                var updatedFolder = folder
                updatedFolder.isFavorite.toggle()

                folders.remove(at: index)
                folders.append(updatedFolder)
                folders.sort { $0.title < $1.title }

                FirebaseManager.shared.updateFolder(updatedFolder)
            }
        }
    }

    func delete(_ selectedFolder: Folder) {
        for (index, folder) in folders.enumerated() {
            if folder.id == selectedFolder.id {
                FirebaseManager.shared.deleteFolder(folder) { [weak self] error in
                    guard let self = self else { return }
                    self.alertItem = AlertItem(errorMessage: error.localizedDescription)
                }

                folders.remove(at: index)
            }
        }
    }
}
