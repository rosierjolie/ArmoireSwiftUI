//
// AccountScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/19/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct AccountScreen: View {
    var body: some View {
        List {
            Section {
                NavigationLink(destination: Text("Change photo")) {
                    HStack {
                        AsyncImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b5/191125_Taylor_Swift_at_the_2019_American_Music_Awards_%28cropped%29.png")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color(.lightGray), lineWidth: 1))
                        } placeholder: {
                            Image("Placeholder")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        }

                        Spacer()

                        Text("Change Avatar")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                NavigationLink(destination: Text("Change Username")) {
                    HStack {
                        Text("Username")

                        Spacer()

                        Text("rosierjolie")
                            .foregroundColor(.secondary)
                    }
                }

                NavigationLink(destination: Text("Change Email")) {
                    HStack {
                        Text("Email")

                        Spacer()

                        Text("rosierjolie@gmail.com")
                            .accentColor(.secondary)
                    }
                }

                NavigationLink(destination: Text("Change Password")) {
                    Text("Password")
                }
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
