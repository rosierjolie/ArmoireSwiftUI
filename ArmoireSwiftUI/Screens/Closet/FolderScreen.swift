//
// FolderScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct FolderScreen: View {
    @StateObject private var viewModel = FolderViewModel()

    @State private var isFolderFormVisible = false
    @State private var isClothingFormVisible = false

    var folder: Folder

    var body: some View {
        List {
            ForEach(viewModel.clothes, id: \.id) { clothing in
                ClothingCell(clothing: clothing)
            }

            ListFooterView(itemName: "Item", count: viewModel.clothes.count)
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Dresses")
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer,
            prompt: Text("Search \(folder.title)")
        )
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
