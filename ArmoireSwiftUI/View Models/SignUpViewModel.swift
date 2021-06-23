//
// SignUpViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/20/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Foundation

final class SignUpViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    func registerUser() {

    }
}