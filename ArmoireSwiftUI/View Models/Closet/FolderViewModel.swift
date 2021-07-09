//
// FolderViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Foundation

final class FolderViewModel: ObservableObject {
    @Published var clothes: [Clothing] = []
    @Published var searchText = ""

    @Published var isClothingFormVisible = false
    @Published var isFolderFormVisible = false

    @Published var alertItem: AlertItem?
    @Published var isLoading = false

    var folder: Folder

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
            case .success(let clothes): self.clothes = clothes.sorted { $0.name < $1.name }
            case .failure(let error): self.alertItem = .init(errorMessage: error.localizedDescription)
            }
        }
    }
}
