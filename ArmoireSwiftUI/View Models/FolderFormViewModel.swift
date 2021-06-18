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

    func setPreviousValues(folder: Folder?) {
        guard let folder = folder else { return }

        title = folder.title
        description = folder.description ?? ""
        isMarkedAsFavorite = folder.isFavorite
    }

    func submitFolder() {
        
    }
}
