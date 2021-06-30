//
// FolderFormScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Introspect
import SwiftUI

struct FolderFormScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = FolderFormViewModel()

    var folder: Folder?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    AMTextField("Title", text: $viewModel.title)
                        .submitLabel(.done)

                    AMNavButton(title: "Enter Description") {
                        DescriptionScreen(text: $viewModel.description)
                    }

                    Toggle("Mark as favorite?", isOn: $viewModel.isMarkedAsFavorite)
                        .tint(.accentColor)
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Create Folder")
            .toolbar {
                FormNavigationToolbar(cancel: { dismiss() }, done: viewModel.submitFolder)
            }
        }
        .navigationViewStyle(.stack)
        .onAppear { viewModel.setPreviousValues(folder: folder) }
    }
}

struct FolderFormScreenPreviews: PreviewProvider {
    static var previews: some View {
        FolderFormScreen()
    }
}
