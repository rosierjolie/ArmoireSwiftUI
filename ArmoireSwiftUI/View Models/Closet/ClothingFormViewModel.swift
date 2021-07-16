//
// ClothingFormViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

final class ClothingFormViewModel: ObservableObject {
    // Used to track properties when the user selects a new image from the image picker
    @Published var sourceTypeItem: SourceTypeItem?
    @Published var selectedImage: UIImage?

    // Required fields
    @Published var imageUrl: URL? = nil
    @Published var name = ""
    @Published var brand = ""
    @Published var quantity = 0
    @Published var color: Color = .accentColor
    @Published var markedAsFavorite = false

    // Optional fields
    @Published var description = ""
    @Published var size = ""
    @Published var material = ""
    @Published var url = ""

    @Published var alertItem: AlertItem?
    @Published var isLoading = false

    var folderId = ""

    private var selectedClothing: Clothing?

    init(folderId: String) {
        self.folderId = folderId
    }

    init(clothing: Clothing? = nil) {
        setPreviousValues(clothing: clothing)
    }

    func setPreviousValues(clothing: Clothing?) {
        guard let clothing = clothing else { return }
        selectedClothing = clothing

        imageUrl = clothing.imageUrl
        name = clothing.name
        brand = clothing.brand
        quantity = clothing.quantity
        color = Color(hex: clothing.color)

        let selectedColor = Color(hex: clothing.color)
        print(selectedColor.hexDescription(includeAlpha: true))

        markedAsFavorite = clothing.isFavorite

        description = clothing.description ?? ""
        size = clothing.size ?? ""
        material = clothing.material ?? ""
        url = clothing.url ?? ""
    }

    // MARK: - Action methods

    func submitClothing(completed: @escaping (_ clothing: Clothing) -> Void) {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Shows an error if a name was not entered
            return alertItem = .init(errorMessage: "A title is required when adding a clothing item. Please enter a title and try again.")
        } else if brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Shows an error if a brand was not entered
            return alertItem = .init(errorMessage: "A brand is required when adding a clothing item. Please enter a brand and try again.")
        } else {
            if let clothing = selectedClothing {
                // Run actions for updating an old clothing item

                if selectedImage != nil {
                    // Deletes the previous image from firebase if a new image is selected
                    FirebaseManager.shared.deleteClothingImage(for: clothing) { [weak self] error in
                        guard let self = self else { return }
                        return self.alertItem = .init(errorMessage: error.localizedDescription)
                    }
                }

                let updatedClothing = Clothing(
                    id: clothing.id,
                    name: name,
                    brand: brand,
                    quantity: quantity,
                    color: color.hexDescription(includeAlpha: false),
                    isFavorite: markedAsFavorite,
                    description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description,
                    size: size.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : size,
                    material: material.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : material,
                    url: url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : url,
                    dateCreated: clothing.dateCreated,
                    dateUpdated: Date(),
                    folder: clothing.folder,
                    folderId: clothing.folderId
                )

                isLoading = true

                FirebaseManager.shared.updateClothing(updatedClothing, image: selectedImage) { [weak self] result in
                    guard let self = self else { return }

                    self.isLoading = false

                    switch result {
                    case .success(let clothing): completed(clothing)
                    case .failure(let error): self.alertItem = .init(errorMessage: error.localizedDescription)
                    }
                }
            } else {
                // Run actions for creating a new clothing item

                guard let image = selectedImage else {
                    return alertItem = .init(errorMessage: "An image is required when adding a clothing item. Please add an image and try again.")
                }

                let newClothing = Clothing(
                    name: name,
                    brand: brand,
                    quantity: quantity,
                    color: color.hexDescription(includeAlpha: true),
                    isFavorite: markedAsFavorite,
                    description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description,
                    size: size.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : size,
                    material: material.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : material,
                    url: url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : url,
                    folderId: folderId
                )

                isLoading = true

                FirebaseManager.shared.addClothing(with: newClothing, image: image, folderId: folderId) { [weak self] result in
                    guard let self = self else { return }

                    self.isLoading = false

                    switch result {
                    case .success(let clothing): completed(clothing)
                    case .failure(let error): self.alertItem = .init(errorMessage: error.localizedDescription)
                    }
                }
            }
        }
    }
}
