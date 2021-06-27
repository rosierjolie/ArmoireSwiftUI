//
// FolderCell.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct FolderCell: View {
    @Environment(\.colorScheme) private var colorScheme

    var folder: Folder

    private var rowBackground: some View {
        VStack(spacing: 0) {
            Color(colorScheme == .light ? .white : .systemGray6)

            Rectangle()
                .fill(Color.separator)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 1)
        }
        .ignoresSafeArea()
    }

    var body: some View {
        ZStack {
            NavigationLink(destination: FolderScreen(folder: folder)) {
                EmptyView()
            }
            .opacity(0)

            VStack(alignment: .leading) {
                HStack {
                    Text(folder.title)
                        .systemScaledFont(size: 20, weight: .medium)
                        .foregroundColor(.accentColor)

                    Spacer()

                    Image(systemName: "star.fill")
                        .foregroundColor(folder.isFavorite ? .yellow : .gray)
                }

                Text(folder.description ?? "No description.")
                    .systemScaledFont(size: 11)
                    .lineLimit(2)
                    .padding(.bottom, 8)

                Text("2 items")
                    .systemScaledFont(size: 9)
                    .foregroundColor(.gray)
            }
        }
        .listRowBackground(rowBackground)
        .listRowInsets(.init(top: 10, leading: 20, bottom: 11, trailing: 20))
        .listRowSeparator(.hidden)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button(action: {}) {
                Label(folder.isFavorite ? "Unfavorite" : "Favorite", systemImage: "star")
                    .symbolVariant(folder.isFavorite ? .slash : .fill)
            }
            .tint(folder.isFavorite ? .gray : .yellow)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: {}) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct FolderCellPreviews: PreviewProvider {
    static var previews: some View {
        FolderCell(folder: .example)
            .previewLayout(.sizeThatFits)
    }
}
