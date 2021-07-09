//
// Runway.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct ItemNode: Codable {
    var id: String
    var imageUrl: String
    var xPosition: Double
    var yPosition: Double
    var zPosition: Double
    var scale: Double? = nil
}

struct Runway: Codable {
    @DocumentID var id: String? = nil
    var dataUrl: URL?
    var title: String
    var isFavorite = false
    var isSharing = false
    var dateCreated = Date()
    var dateUpdated: Date? = nil
    var userId: String?

    static var example: Runway {
        Runway(title: "Evening Outfit 2021", isFavorite: true, isSharing: true)
    }
}
