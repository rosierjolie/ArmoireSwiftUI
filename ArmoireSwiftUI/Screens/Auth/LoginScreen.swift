//
// LoginScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import AlertToast
import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var viewModel = LoginViewModel()

    @State private var resetScreenIsVisible = false
    @State private var signUpScreenIsVisible = false
    @FocusState private var focusedField: LoginField?

    private enum LoginField: Hashable { case email, password }

    private func handleSubmit() {
        switch focusedField {
        case .email: focusedField = .password
        default: focusedField = nil
        }
    }

    private func signInButtonTapped() {
        focusedField = nil
        viewModel.signInUser { authViewModel.userIsLoggedIn = true }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("Login Logo")
                    .padding(.bottom, 20)

                HStack {
                    Text("Login")
                        .font(.largeTitle.bold())

                    Spacer()
                }

                AMTextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .submitLabel(.next)

                AMTextField("Password", text: $viewModel.password)
                    .isSecure()
                    .focused($focusedField, equals: .password)
                    .textContentType(.password)
                    .submitLabel(.go)

                AMButton(title: "Sign In", action: signInButtonTapped)

                Button("Forgot Password?", action: { resetScreenIsVisible = true })
                    .systemScaledFont(size: 18, weight: .medium)
                    .foregroundColor(Color(.systemGray))

                Spacer()

                HStack(spacing: 0) {
                    Text("Don't have an account? ")

                    Button("Sign up", action: { signUpScreenIsVisible = true })
                        .foregroundColor(Color("AccentColor"))
                }
                .systemScaledFont(size: 18, weight: .medium)
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: .default(alertItem.buttonTitle)
                )
            }
            .fullScreenCover(isPresented: $resetScreenIsVisible) { ResetScreen() }
            .fullScreenCover(isPresented: $signUpScreenIsVisible) { SignUpScreen() }
            .navigationBarHidden(true)
            .onSubmit(handleSubmit)
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            .toast(isPresenting: $viewModel.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Please wait")
            }
            .toolbar { FormKeyboardToolbar(dismissAction: { focusedField = nil }) }
        }
        .navigationViewStyle(.stack)
    }
}

struct LoginScreenPreviews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
