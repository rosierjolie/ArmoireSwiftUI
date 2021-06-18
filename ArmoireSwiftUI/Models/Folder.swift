//
// Folder.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Foundation

struct Folder: Codable, Identifiable {
    var id = UUID()
    var title: String
    var description: String?
    var isFavorite: Bool
    var userId: String?

    static var example: Folder {
        Folder(
            title: "Dresses",
            description: "Collection of formal wear.",
            isFavorite: true
        )
    }
}
