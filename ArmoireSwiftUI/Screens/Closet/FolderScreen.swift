//
// FolderScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct FolderScreen: View {
    @State private var searchText = ""
    @State private var isFolderFormVisible = false
    @State private var isClothingFormVisible = false

    @State private var clothes: [Clothing] = Array(repeating: .example, count: 20)

    var folder: Folder

    var body: some View {
        List {
            ForEach(clothes) { clothing in
                ClothingCell(clothing: clothing)
            }

            ListFooterView(itemName: "Item", count: clothes.count)
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Dresses")
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: Text("Search \(folder.title)"))
        .sheet(isPresented: $isFolderFormVisible) { FolderFormScreen(folder: folder) }
        .sheet(isPresented: $isClothingFormVisible) { ClothingFormScreen() }
        .toolbar {
            Menu {
                Button(action: { isFolderFormVisible = true }) {
                    Label("Edit folder", systemImage: "pencil")
                }

                Button(action: { isClothingFormVisible = true }) {
                    Label("Add clothing", systemImage: "plus")
                }
            } label: {
                Label("Folder actions", systemImage: "ellipsis.circle")
            }
        }
    }
}

struct FolderScreenPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FolderScreen(folder: .example)
        }
        .navigationViewStyle(.stack)
    }
}
