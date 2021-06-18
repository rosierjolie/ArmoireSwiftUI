//
// ClothingScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct ClothingScreen: View {
    @State private var isClothingFormVisible = false

    var clothing: Clothing

    private func getInfoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: clothing.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 300)
                        .clipped()
                } placeholder: {
                    Image("Placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 300)
                        .clipped()
                }

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(clothing.name)
                            .font(.system(size: 36, weight: .medium))
                            .foregroundColor(.accentColor)

                        Spacer()

                        ColorPicker("Color", selection: .constant(Color(hex: clothing.color)))
                            .labelsHidden()
                            .disabled(true)
                    }

                    Text(clothing.brand)
                        .font(.system(size: 24, weight: .medium))
                }
                .padding(.top, 10)
                .padding(.horizontal, 12)
                .padding(.bottom, 20)

                if let description = clothing.description {
                    ClothingSection(title: "About")

                    Text(description)
                        .font(.system(size: 14, weight: .regular))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                }

                ClothingSection(title: "Info")

                VStack(spacing: 16) {
                    getInfoRow(title: "Quantity", value: "\(clothing.quantity)")

                    if let size = clothing.size {
                        getInfoRow(title: "Size", value: size)
                    }

                    if let material = clothing.material {
                        getInfoRow(title: "Material", value: material)
                    }
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.vertical, 10)
                .padding(.horizontal, 12)

                if let clothingUrl = clothing.url, let url = URL(string: clothingUrl) {
                    ClothingSection(title: "URL")

                    Link(clothingUrl, destination: url)
                        .foregroundColor(Color(.systemTeal))
                        .lineLimit(1)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(clothing.name)
        .toolbar {
            Button(action: { isClothingFormVisible = true }) {
                Label("Edit item", systemImage: "pencil.circle")
            }
        }
        .sheet(isPresented: $isClothingFormVisible) {
            ClothingFormScreen(clothing: clothing)
        }
    }
}

struct ClothingScreenPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ClothingScreen(clothing: .example)
        }
        .navigationViewStyle(.stack)
    }
}
