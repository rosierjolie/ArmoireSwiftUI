//
// ClosetScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct ClosetScreen: View {
    @Environment(\.isSearching) private var isSearching

    @StateObject private var viewModel = ClosetViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading folders")
            } else {
                List {
                    ForEach(viewModel.folders, id: \.id) { folder in
                        FolderCell(folder: folder)
                            .environmentObject(viewModel)
                    }

                    ListFooterView(itemName: "Folder", count: viewModel.folders.count)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Closet")
        .onAppear(perform: viewModel.fetchFolders)
        .refreshable(action: viewModel.fetchFolders)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search Folders"
        )
        .sheet(isPresented: $viewModel.isFolderFormVisible, onDismiss: viewModel.fetchFolders) {
            FolderFormScreen()
        }
        .toolbar {
            Button(action: { viewModel.isFolderFormVisible = true }) {
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
