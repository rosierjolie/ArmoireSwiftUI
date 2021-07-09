//
// ClothingCell.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Kingfisher
import SwiftUI

struct ClothingCell: View {
    @Environment(\.colorScheme) private var colorScheme

    var clothing: Clothing

    private var rowBackground: some View {
        VStack(spacing: 0) {
            Color(colorScheme == .light ? .white : .systemGray6)

            Rectangle()
                .fill(Color.separator)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 4)
        }
        .ignoresSafeArea()
    }

    var body: some View {
        ZStack {
            NavigationLink(destination: ClothingScreen(clothing: clothing)) {
                EmptyView()
            }
            .opacity(0)

            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    KFImage(clothing.imageUrl)
                        .resizable()
                        .placeholder {
                            Image("Placeholder")
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(clothing.name)
                                .systemScaledFont(size: 20, weight: .medium)
                                .foregroundColor(.accentColor)

                            Spacer()

                            Image(systemName: "star.fill")
                                .foregroundColor(clothing.isFavorite ? .yellow : .gray)
                                .systemScaledFont(size: 20)
                        }

                        Text(clothing.brand)
                            .systemScaledFont(size: 12, weight: .medium)

                        Text(clothing.description ?? "No description.")
                            .systemScaledFont(size: 11)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2)
                            .padding(.bottom, 11)

                        HStack {
                            Text("Quantity: \(clothing.quantity)")

                            Spacer()

                            if let date = clothing.dateUpdated {
                                Text("Last updated on \(date.convertToShortFormat())")
                            } else {
                                Text("Created on \(clothing.dateCreated.convertToShortFormat())")
                            }
                        }
                        .systemScaledFont(size: 9)
                        .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listRowBackground(rowBackground)
        .listRowInsets(.init(top: 10, leading: 20, bottom: 14, trailing: 20))
        .listRowSeparator(.hidden)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button(action: {}) {
                Label(clothing.isFavorite ? "Unfavorite" : "Favorite", systemImage: "star")
                    .symbolVariant(clothing.isFavorite ? .slash : .fill)
            }
            .tint(clothing.isFavorite ? .gray : .yellow)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: {}) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct ClothingCellPreviews: PreviewProvider {
    static var previews: some View {
        ClothingCell(clothing: .example)
            .previewLayout(.sizeThatFits)
    }
}
