//
// User.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/19/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Foundation


struct User: Codable, Identifiable {
    var id = UUID()
    var avatarUrl: URL?
    var firstName: String
    var lastName: String
    var username: String
    var email: String

    static var example: User {
        User(
            firstName: "Geraldine",
            lastName: "Turcios",
            username: "rosierjolie",
            email: "rosierjolie1999@gmail.com"
        )
    }
}
