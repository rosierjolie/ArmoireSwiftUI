//
// FolderScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct FolderScreen: View {
    @StateObject private var viewModel: FolderViewModel

    init(folder: Folder) {
        _viewModel = StateObject(wrappedValue: FolderViewModel(folder: folder))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading clothes")
            } else {
                List {
                    ForEach(viewModel.clothes, id: \.id) { clothing in
                        ClothingCell(clothing: clothing)
                    }

                    ListFooterView(itemName: "Item", count: viewModel.clothes.count)
                }
                .listStyle(.plain)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.folder.title)
        .onAppear(perform: viewModel.fetchClothes)
        .refreshable(action: viewModel.fetchClothes)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search \(viewModel.folder.title)"
        )
        .sheet(isPresented: $viewModel.isFolderFormVisible) {
            FolderFormScreen(folder: viewModel.folder) { folder in
                viewModel.folder = folder
            }
        }
        .sheet(isPresented: $viewModel.isClothingFormVisible) {
            ClothingFormScreen()
        }
        .toolbar {
            Menu {
                Button {
                    viewModel.isFolderFormVisible = true
                } label: {
                    Label("Edit folder", systemImage: "pencil")
                }

                Button {
                    viewModel.isClothingFormVisible = true
                } label: {
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
