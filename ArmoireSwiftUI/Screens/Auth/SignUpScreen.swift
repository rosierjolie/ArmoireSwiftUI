//
// SignUpScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct SignUpScreen: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = SignUpViewModel()
    @FocusState private var focusedField: SignUpField?

    private enum SignUpField: Hashable {
        case username, email, password, confirmPassword
    }

    private func handleSubmit() {
        switch focusedField {
        case .username: focusedField = .email
        case .email: focusedField = .password
        case .password: focusedField = .confirmPassword
        default: focusedField = nil
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Button(action: dismiss.callAsFunction) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.accentColor)
                        .padding(.bottom, 10)
                }

                Text("Sign Up")
                    .font(.largeTitle.bold())

                AMButton(title: "Add Avatar", action: {})

                Group {
                    AMTextField("@Username", text: $viewModel.username)
                        .focused($focusedField, equals: .username)

                    AMTextField("Email", text: $viewModel.email)
                        .focused($focusedField, equals: .email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .submitLabel(.next)

                AMTextField("Password", text: $viewModel.password)
                    .isSecure()
                    .focused($focusedField, equals: .password)
                    .textContentType(.oneTimeCode)
                    .submitLabel(.next)

                AMTextField("Confirm Password", text: $viewModel.confirmPassword)
                    .isSecure()
                    .focused($focusedField, equals: .confirmPassword)
                    .textContentType(.oneTimeCode)
                    .submitLabel(.done)

                AMButton(title: "Register", action: {})

                Spacer()
            }
            .navigationBarHidden(true)
            .onSubmit(handleSubmit)
            .padding([.top, .horizontal], 20)
            .toolbar { FormKeyboardToolbar(dismissAction: { focusedField = nil }) }
        }
    }
}

struct SignUpScreenPreviews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
