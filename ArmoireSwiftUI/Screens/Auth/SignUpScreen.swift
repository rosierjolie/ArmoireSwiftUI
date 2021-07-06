//
// SignUpScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import AlertToast
import SwiftUI

struct SignUpScreen: View {
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var viewModel = SignUpViewModel()

    @State private var isSourceTypeDialogVisible = false
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

    private func registerButtonTapped() {
        focusedField = nil
        viewModel.registerUser(completed: dismiss.callAsFunction)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Button(action: dismiss.callAsFunction) {
                        Image(systemName: "xmark.circle")
                            .systemScaledFont(size: 24, weight: .semibold)
                            .foregroundColor(.accentColor)
                            .padding(.bottom, 10)
                    }

                    Text("Sign Up")
                        .font(.largeTitle.bold())

                    SelectedImageView(selectedImage: viewModel.selectedImage)

                    AMButton(title: "Add Avatar") { isSourceTypeDialogVisible = true }

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

                    AMButton(title: "Register", action: registerButtonTapped)

                    Spacer()
                }
                .padding([.top, .horizontal], 20)
            }
            .navigationBarHidden(true)
            .toolbar { FormKeyboardToolbar(dismissAction: { focusedField = nil }) }
        }
        .actionSheet(isPresented: $isSourceTypeDialogVisible) {
            ActionSheet(
                title: Text("Photo"),
                message: Text("Please select a method to add an image."),
                buttons: [
                    .default(
                        Text("Camera"),
                        action: { viewModel.sourceTypeItem = .init(sourceType: .camera) }
                    ),
                    .default(
                        Text("Photo Library"),
                        action: { viewModel.sourceTypeItem = .init(sourceType: .photoLibrary) }
                    ),
                    .cancel(Text("Cancel"))
                ]
            )
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: .default(alertItem.buttonTitle)
            )
        }
        .onSubmit(handleSubmit)
        .sheet(item: $viewModel.sourceTypeItem) { sourceTypeItem in
            ImagePicker(
                sourceType: sourceTypeItem.sourceType,
                selectedImage: $viewModel.selectedImage
            )
        }
        .toast(isPresenting: $viewModel.isLoading) {
            AlertToast(displayMode: .alert, type: .loading, title: "Creating account")
        }
    }
}

struct SignUpScreenPreviews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
