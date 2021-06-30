//
// UsernameScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct UsernameScreen: View {
    @State private var username = ""

    var oldUsername: String

    var body: some View {
        VStack {
            AMTextField("@Username", text: $username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .submitLabel(.done)

            Spacer()
        }
        .padding([.top, .horizontal], 20)
        .navigationTitle("Change Username")
        .onAppear { username = oldUsername }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: {})
            }
        }
    }
}

struct UsernameScreenPreviews: PreviewProvider {
    static var previews: some View {
        UsernameScreen(oldUsername: "username123")
    }
}
