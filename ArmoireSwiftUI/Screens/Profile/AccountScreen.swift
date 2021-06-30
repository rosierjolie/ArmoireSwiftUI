//
// AccountScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/19/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Kingfisher
import SwiftUI

struct AccountScreen: View {
    var body: some View {
        List {
            Section {
                NavigationLink(destination: AvatarScreen()) {
                    HStack {
                        KFImage(URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b5/191125_Taylor_Swift_at_the_2019_American_Music_Awards_%28cropped%29.png"))
                            .resizable()
                            .placeholder {
                                Image("Placeholder")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            }
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.lightGray), lineWidth: 1))

                        Spacer()

                        Text("Change Avatar")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                NavigationCell(title: "Username", subtitle: "username123") {
                    UsernameScreen(oldUsername: "username123")
                }

                NavigationCell(title: "Email", subtitle: "rosierjolie@gmail.com") {
                    EmailScreen(oldEmail: "rosierjolie@gmail.com")
                }

                NavigationLink("Password", destination: PasswordScreen())
            }

            Section {
                Button("Delete Account", role: .destructive, action: {})
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Account")
    }
}

struct AccountScreenPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountScreen()
        }
        .navigationViewStyle(.stack)
    }
}
