//
// AuthViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import FirebaseAuth

final class AuthViewModel: ObservableObject {
    @Published var userIsLoggedIn = false

    func checkAuthenticatedUser() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }

            if user == nil {
                self.userIsLoggedIn = false
            }
        }
    }
}
