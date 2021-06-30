//
// LoginViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/20/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import FirebaseAuth

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    @Published var alertItem: AlertItem?

    func signInUser() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.alertItem = AlertItem(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
            } else {
                print("Logging in")
            }
        }
    }
}
