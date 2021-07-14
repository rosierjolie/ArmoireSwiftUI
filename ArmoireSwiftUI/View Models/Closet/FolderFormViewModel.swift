//
// FolderFormViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Foundation

final class FolderFormViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var isMarkedAsFavorite = false

    @Published var alertItem: AlertItem?

    var selectedFolder: Folder?

    func setPreviousValues(folder: Folder?) {
        guard let folder = folder else { return }
        selectedFolder = folder

        title = folder.title
        description = folder.description ?? ""
        isMarkedAsFavorite = folder.isFavorite
    }

    func submitFolder(completed: @escaping (_ folder: Folder) -> Void) {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return alertItem = AlertItem(errorMessage: "The title text field must not be empty.")
        } else {
            if let folder = selectedFolder {
                let description = description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description

                var updatedFolder = folder
                updatedFolder.title = title
                updatedFolder.description = description
                updatedFolder.isFavorite = isMarkedAsFavorite

                FirebaseManager.shared.updateFolder(updatedFolder) { folder in
                    completed(folder)
                }
            } else {
                let description = description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description
                let folder = Folder(title: title, description: description, isFavorite: isMarkedAsFavorite, itemCount: 0)

                FirebaseManager.shared.createFolder(with: folder) { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case .success(let folder): completed(folder)
                    case .failure(let error): self.alertItem = AlertItem(errorMessage: error.localizedDescription)
                    }
                }
            }
        }
    }
}
