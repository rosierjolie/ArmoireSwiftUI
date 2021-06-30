//
// ProfileScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import FirebaseAuth
import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        List {
            Section(header: ProfileHeaderView(user: .example)) {
                NavigationLink(destination: AccountScreen()) {
                    Text("Account")
                }

                NavigationLink(destination: NotificationsScreen()) {
                    Text("Notifications")
                }
            }

            Section {
                NavigationLink(destination: AboutScreen()) {
                    Text("About")
                }

                NavigationLink(destination: TipJarScreen()) {
                    Text("Tip Jar")
                }
            }

            Section {
                Button("Log Out", role: .destructive, action: {})
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Profile")
    }
}

struct ProfileScreenPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileScreen()
        }
        .navigationViewStyle(.stack)
    }
}
