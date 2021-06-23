//
// ClothingFormViewModel.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

final class ClothingFormViewModel: ObservableObject {
    @Published var sourceTypeItem: SourceTypeItem?
    @Published var selectedImage: UIImage?

    @Published var name = ""
    @Published var brand = ""
    @Published var quantity = 0
    @Published var color: Color = .accentColor
    @Published var markedAsFavorite = false

    @Published var description = ""
    @Published var size = ""
    @Published var material = ""
    @Published var url = ""

    func setPreviousValues(clothing: Clothing?) {
        guard let clothing = clothing else { return }

        // Required fields
        name = clothing.name
        brand = clothing.brand
        quantity = clothing.quantity
        color = Color(hex: clothing.color)
        markedAsFavorite = clothing.isFavorite

        // Optional fields
        description = clothing.description ?? ""
        size = clothing.size ?? ""
        material = clothing.material ?? ""
        url = clothing.url ?? ""
    }

    func submitClothing() {
        
    }
}
