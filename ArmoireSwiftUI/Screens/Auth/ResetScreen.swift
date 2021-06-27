//
// ResetScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct ResetScreen: View {
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: dismiss.callAsFunction) {
                    Image(systemName: "xmark.circle")
                        .systemScaledFont(size: 24, weight: .semibold)
                        .foregroundColor(.accentColor)
                }

                Spacer()
            }

            Text("Forgot Password?")
                .systemScaledFont(size: 30, weight: .semibold)

            Text("Please enter the email you used to register your account. You should recieve password reset instructions in the entered email.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)

            AMTextField("Email", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .submitLabel(.done)

            AMButton(title: "Reset", action: {})

            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 20)
    }
}

struct ResetScreenPreviews: PreviewProvider {
    static var previews: some View {
        ResetScreen()
    }
}
