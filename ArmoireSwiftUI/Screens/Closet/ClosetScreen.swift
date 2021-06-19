//
// ClosetScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct ClosetScreen: View {
    @State private var searchText = ""
    @State private var isFolderFormVisible = false

    @State private var folders: [Folder] = Array(repeating: .example, count: 20)

    var body: some View {
        List {
            ForEach(folders) { folder in
                FolderCell(folder: folder)
            }

            ListFooterView(itemName: "Folder", count: folders.count)
        }
        .listStyle(.plain)
        .navigationTitle("Closet")
        .searchable("Search Folders", text: $searchText, placement: .navigationBarDrawer)
        .sheet(isPresented: $isFolderFormVisible) { FolderFormScreen() }
        .toolbar {
            Button(action: { isFolderFormVisible = true }) {
                Image(systemName: "plus.circle")
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
