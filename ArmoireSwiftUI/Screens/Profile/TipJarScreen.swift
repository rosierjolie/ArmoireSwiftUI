//
// TipJarScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct TipJarScreen: View {
    @Environment(\.colorScheme) private var colorScheme

    var backgroundColor: Color {
        colorScheme == .light ? .init(.systemGray6) : .init(.systemBackground)
    }

    var cellColor: Color {
        colorScheme == .light ? .init(.systemBackground) : .init(.systemGray6)
    }

    private func getTipJarRow(title: String, amount: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)

                Spacer()

                Text(amount)
                    .fontWeight(.semibold)
                    .padding(8)
                    .background(Color.accentColor)
                    .cornerRadius(5)
                    .foregroundColor(.white)
            }
            .padding()
            .background(cellColor)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                VStack {
                    Text("Love what Armoire provides? Want to support future development?")
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)

                    Text("Select an amount you wish to tip!")
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical)

                getTipJarRow(title: "Small Tip", amount: "$0.99", action: {})
                getTipJarRow(title: "Medium Tip", amount: "$2.99", action: {})
                getTipJarRow(title: "Large Tip", amount: "$4.99", action: {})
                getTipJarRow(title: "Massive Tip", amount: "$9.99", action: {})

                VStack {
                    Text("Thank you for all the support! 😄")
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical)
            }
        }
        .background(backgroundColor, ignoresSafeAreaEdges: .all)
        .navigationTitle("Tip Jar")
    }
}

struct TipJarScreenPreviews: PreviewProvider {
    static var previews: some View {
        TipJarScreen()
    }
}
