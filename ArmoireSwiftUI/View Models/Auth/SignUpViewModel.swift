//
// SignUpViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/20/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import FirebaseAuth
import SwiftUI

final class SignUpViewModel: ObservableObject {
    @Published var sourceTypeItem: SourceTypeItem?
    @Published var selectedImage: UIImage?

    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published var alertItem: AlertItem?
    @Published var isLoading = false

    func registerUser(successCompletion: @escaping () -> Void) {
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertItem = AlertItem(errorMessage: "The username field is empty. Please enter a username")
            return
        } else if password != confirmPassword {
            alertItem = AlertItem(errorMessage: "The passwords entered do not match. Please try again.")
            return
        }

        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.alertItem = AlertItem(errorMessage: error.localizedDescription)
                return
            }

            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = self.username

            if let image = self.selectedImage {
                FirebaseManager.shared.uploadAvatarImage(for: image, name: self.username) { result in
                    switch result {
                    case .success(let url): changeRequest?.photoURL = url
                    case .failure(let error): self.alertItem = AlertItem(errorMessage: error.rawValue)
                    }
                }
            }

            changeRequest?.commitChanges { error in
                if let error = error {
                    self.alertItem = AlertItem(errorMessage: error.localizedDescription)
                    return
                }
            }

            self.isLoading = false

            successCompletion()
        }
    }
}
