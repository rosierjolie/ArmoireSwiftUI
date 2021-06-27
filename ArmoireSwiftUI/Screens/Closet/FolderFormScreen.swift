//
// FolderFormScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct FolderFormScreen: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = FolderFormViewModel()
    @FocusState private var focusedField: Field?

    var folder: Folder?

    private enum Field: Hashable { case title, description }

    private func handleSubmit() {
        switch focusedField {
        case .title: focusedField = .description
        default: focusedField = nil
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                AMTextField("Title", text: $viewModel.title)
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)

                AMTextField("Enter description", text: $viewModel.description)
                    .focused($focusedField, equals: .description)
                    .submitLabel(.done)

                Toggle("Mark as favorite?", isOn: $viewModel.isMarkedAsFavorite)
                    .tint(.accentColor)

                Spacer()
            }
            .padding(20)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Create Folder")
            .toolbar {
                FormNavigationToolbar(cancel: { dismiss() }, done: viewModel.submitFolder)
                FormKeyboardToolbar(dismissAction: { focusedField = nil })
            }
        }
        .onAppear { viewModel.setPreviousValues(folder: folder) }
        .onSubmit(handleSubmit)
        .navigationViewStyle(.stack)
    }
}

struct FolderFormScreenPreviews: PreviewProvider {
    static var previews: some View {
        FolderFormScreen()
    }
}
