//
// ClothingFormScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import AlertToast
import SwiftUI

struct ClothingFormScreen: View {
    @Environment(\.dismiss) private var dismiss

    @FocusState private var focusedField: ClothingField?
    @State private var isNewClothing = false
    @State private var isSourceTypeDialogVisible = false
    @StateObject private var viewModel: ClothingFormViewModel

    var didUpdateClothing: ((_ clothing: Clothing) -> Void)?

    private enum ClothingField: Hashable {
        case name, brand, description, size, material, url
    }

    /// The following **init** method takes in a *folderId* to be used in creating a new clothing
    /// item. The *folderId* assures that the clothing item is assigned to the correct folder. A
    /// callback function of *didUpdateClothing* is used in case the parent view needs access to
    /// the instance of *clothing* before being dismissed.
    ///
    /// - Parameters:
    ///   - folderId: The folder that the clothing item will belong to
    ///   - didUpdateClothing: Callback function to pass *clothing* back to the parent view
    init(folderId: String, didUpdateClothing: ((_ clothing: Clothing) -> Void)? = nil) {
        _isNewClothing = State(initialValue: true)
        _viewModel = StateObject(wrappedValue: .init(folderId: folderId))
        self.didUpdateClothing = didUpdateClothing
    }

    /// The following **init** method takes in a *clothing* instance to be used in updating an
    /// existing clothing item in the database. A callback function of *didUpdatingClothing* is
    /// used in case the parent view needs access to the updated instance of *clothing* before
    /// being dismissed.
    ///
    /// - Parameters:
    ///   - clothing: A previously created clothing item to be updated
    ///   - didUpdateClothing: Callback function to pass *clothing* back to the parent view
    init(clothing: Clothing, didUpdateClothing: ((_ clothing: Clothing) -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: .init(clothing: clothing))
        self.didUpdateClothing = didUpdateClothing
    }

    private func doneButtonTapped() {
        viewModel.submitClothing {
            didUpdateClothing?($0)
            dismiss()
        }
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
                    if let selectedImage = viewModel.selectedImage {
                        HStack {
                            Spacer()

                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 280)

                            Spacer()
                        }
                    } else {
                        // Used to show an image from a previously created clothing item
                        if let imageUrl = viewModel.imageUrl {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 280)
                            } placeholder: {
                                ProgressView("Loading image")
                            }
                        }
                    }

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
                    .systemScaledFont(size: 20)

                    AMNavButton(title: "Enter Description") {
                        DescriptionScreen(text: $viewModel.description)
                    }

                    AMTextField("Size (Optional)", text: $viewModel.size)
                        .focused($focusedField, equals: .size)
                        .submitLabel(.next)

                    AMTextField("Material (Optional)", text: $viewModel.material)
                        .focused($focusedField, equals: .material)
                        .submitLabel(.next)

                    AMTextField("URL (Optional)", text: $viewModel.url)
                        .focused($focusedField, equals: .url)
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .submitLabel(.done)
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("\(isNewClothing ? "Add" : "Edit") Clothing")
            .toolbar {
                FormNavigationToolbar(cancel: dismiss.callAsFunction, done: doneButtonTapped)
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
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: .default(alertItem.buttonTitle)
            )
        }
        .onSubmit(handleSubmit)
        .navigationViewStyle(.stack)
        .sheet(item: $viewModel.sourceTypeItem) { sourceTypeItem in
            ImagePicker(
                sourceType: sourceTypeItem.sourceType,
                selectedImage: $viewModel.selectedImage
            )
        }
        .toast(isPresenting: $viewModel.isLoading) {
            AlertToast(displayMode: .alert, type: .loading, title: "Please wait")
        }
    }
}

struct ClothingFormScreenPreviews: PreviewProvider {
    static var previews: some View {
        ClothingFormScreen(folderId: "")
        ClothingFormScreen(clothing: .example)
    }
}
