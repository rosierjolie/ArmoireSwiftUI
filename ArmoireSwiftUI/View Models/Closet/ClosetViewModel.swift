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

    @Published var error: AMError?

    init() {
        FirebaseManager.shared.fetchFolders { result in
            switch result {
            case .success(let folders): self.folders = folders
            case .failure(let error): self.error = error
            }
        }
    }
}
