//
// Folder.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Folder: Codable {
    @DocumentID var id: String? = nil
    var title: String
    var description: String?
    var isFavorite: Bool
    var itemCount: Int
    var userId: String?

    static var example: Folder {
        Folder(
            title: "Dresses",
            description: "Collection of formal wear.",
            isFavorite: true,
            itemCount: 1
        )
    }
}
