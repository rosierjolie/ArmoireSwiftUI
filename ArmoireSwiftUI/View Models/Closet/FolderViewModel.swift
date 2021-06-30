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
}
