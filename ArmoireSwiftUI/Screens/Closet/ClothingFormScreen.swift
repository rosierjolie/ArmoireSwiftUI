//
// ClothingFormScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct ClothingFormScreen: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = ClothingFormViewModel()
    @FocusState private var focusedField: ClothingField?

    @State private var isSourceTypeDialogVisible = false
    @State private var isOptionalFieldsVisible = false

    var clothing: Clothing?

    private enum ClothingField: Hashable {
        case name, brand, description, size, material, url
    }

    private func handleSubmit() {
        switch focusedField {
        case .name: focusedField = .brand
        case .size: focusedField = .material
        case .material: focusedField = .url
        default: focusedField = nil
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    SelectedImageView(selectedImage: viewModel.selectedImage)

                    AMButton(title: "Add Image") { isSourceTypeDialogVisible = true }

                    AMTextField("Name", text: $viewModel.name)
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)

                    AMTextField("Brand", text: $viewModel.brand)
                        .focused($focusedField, equals: .brand)
                        .submitLabel(.done)

                    Group {
                        Stepper("Quantity: \(viewModel.quantity)", value: $viewModel.quantity, in: 0...100)

                        ColorPicker("Color", selection: $viewModel.color, supportsOpacity: false)

                        Toggle("Mark as favorite?", isOn: $viewModel.markedAsFavorite)
                            .tint(.accentColor)
                    }
                    .font(.system(size: 20))

                    AMButton(title: "\(isOptionalFieldsVisible ? "Hide" : "Show") Optional Fields") {
                        isOptionalFieldsVisible.toggle()
                    }

                    if isOptionalFieldsVisible {
                        AMTextField("Size", text: $viewModel.size)
                            .focused($focusedField, equals: .size)
                            .submitLabel(.next)

                        AMTextField("Material", text: $viewModel.material)
                            .focused($focusedField, equals: .material)
                            .submitLabel(.next)

                        AMTextField("URL", text: $viewModel.url)
                            .focused($focusedField, equals: .url)
                            .keyboardType(.URL)
                            .textContentType(.URL)
                            .submitLabel(.done)
                    }
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit Clothing")
            .toolbar {
                FormNavigationToolbar(cancel: { dismiss() }, done: viewModel.submitClothing)
                FormKeyboardToolbar(dismissAction: { focusedField = nil })
            }
        }
        .actionSheet(isPresented: $isSourceTypeDialogVisible) {
            ActionSheet(
                title: Text("Photo"),
                message: Text("Please select a method to add an image."),
                buttons: [
                    .default(
                        Text("Camera"),
                        action: { viewModel.sourceTypeItem = .init(sourceType: .camera) }
                    ),
                    .default(
                        Text("Photo Library"),
                        action: { viewModel.sourceTypeItem = .init(sourceType: .photoLibrary) }
                    ),
                    .cancel(Text("Cancel"))
                ]
            )
        }
        .onAppear { viewModel.setPreviousValues(clothing: clothing) }
        .onSubmit(handleSubmit)
        .navigationViewStyle(.stack)
        .sheet(item: $viewModel.sourceTypeItem) { sourceTypeItem in
            ImagePicker(
                sourceType: sourceTypeItem.sourceType,
                selectedImage: $viewModel.selectedImage
            )
        }
    }
}

struct ClothingFormScreenPreviews: PreviewProvider {
    static var previews: some View {
        ClothingFormScreen()
    }
}
