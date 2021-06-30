//
// User.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/19/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import FirebaseFirestoreSwift
import Foundation

struct User: Codable {
    @DocumentID var id: String? = nil
    var avatarUrl: URL?
    var firstName: String
    var lastName: String
    var username: String
    var email: String

    static var example: User {
        User(
            avatarUrl: .init(string: "https://upload.wikimedia.org/wikipedia/commons/b/b5/191125_Taylor_Swift_at_the_2019_American_Music_Awards_%28cropped%29.png"),
            firstName: "Taylor",
            lastName: "Swift",
            username: "taylorswift1989",
            email: "taylorswift1989@gmail.com"
        )
    }
}
