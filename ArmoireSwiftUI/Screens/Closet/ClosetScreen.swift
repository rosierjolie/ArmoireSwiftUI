//
// ClosetScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct ClosetScreen: View {
    @StateObject private var viewModel = ClosetViewModel()

    @State private var isFolderFormVisible = false

    var body: some View {
        List {
            ForEach(viewModel.folders, id: \.id) { folder in
                FolderCell(folder: folder)
            }

            ListFooterView(itemName: "Folder", count: viewModel.folders.count)
        }
        .listStyle(.plain)
        .navigationTitle("Closet")
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer,
            prompt: Text("Search Folders")
        )
        .sheet(isPresented: $isFolderFormVisible) { FolderFormScreen() }
        .toolbar {
            Button(action: { isFolderFormVisible = true }) {
                Label("Create folder", systemImage: "plus.circle")
            }
        }
    }
}

struct ClosetScreenPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ClosetScreen()
        }
        .navigationViewStyle(.stack)
    }
}
