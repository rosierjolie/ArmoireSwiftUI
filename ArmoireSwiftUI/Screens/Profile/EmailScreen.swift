//
// EmailScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct EmailScreen: View {
    @State private var email = ""

    var oldEmail: String

    var body: some View {
        VStack {
            AMTextField("Email", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .submitLabel(.done)

            Spacer()
        }
        .padding([.top, .horizontal], 20)
        .navigationTitle("Change Email")
        .onAppear { email = oldEmail }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: {})
            }
        }
    }
}

struct EmailScreenPreviews: PreviewProvider {
    static var previews: some View {
        EmailScreen(oldEmail: User.example.email)
    }
}
