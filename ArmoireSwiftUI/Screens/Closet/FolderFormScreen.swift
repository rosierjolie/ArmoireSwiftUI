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

    var folder: Folder?
    var didUpdateFolder: ((_ folder: Folder) -> Void)?

    private func doneButtonTapped() {
        viewModel.submitFolder {
            didUpdateFolder?($0)
            dismiss()
        }
    }

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
            .navigationTitle("\(folder == nil ? "Create" : "Edit") Folder")
            .toolbar {
                FormNavigationToolbar(cancel: dismiss.callAsFunction, done: doneButtonTapped)
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: .default(alertItem.buttonTitle)
            )
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
