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
    @State private var isLandscapeOrientation = UIDevice.current.orientation.isLandscape

    var clothing: Clothing

    let orientation = NotificationCenter.default
        .publisher(for: UIDevice.orientationDidChangeNotification)
        .map { _ in UIDevice.current.orientation }

    private func handleOrientationChange(_ orientation: UIDeviceOrientation) {
        isLandscapeOrientation = UIDevice.current.orientation.isLandscape
    }

    private func getInfoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }

    @ViewBuilder private var clothingImage: some View {
        if isLandscapeOrientation {
            AsyncImage(url: clothing.imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView("Loading image")
            }
        } else {
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
        }
    }

    private var clothingInformationView: some View {
        LazyVStack(spacing: 10) {
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
            .padding(.horizontal, 12)

            if let description = clothing.description {
                ClothingSection(title: "About")

                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .padding(.horizontal, 12)
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
            .padding(.horizontal, 12)

            if let clothingUrl = clothing.url, let url = URL(string: clothingUrl) {
                ClothingSection(title: "URL")

                HStack {
                    Link(clothingUrl, destination: url)
                        .foregroundColor(Color(.systemTeal))
                        .lineLimit(1)
                        .padding(.horizontal, 12)

                    Spacer()
                }
            }

            HStack {
                Text("Created on \(clothing.dateCreated.convertToDayMonthYearFormat())")

                Spacer()

                if let dateUpdated = clothing.dateUpdated {
                    Text("Updated on \(dateUpdated.convertToDayMonthYearFormat())")
                }
            }
            .foregroundColor(Color(.systemGray))
            .padding(.horizontal, 12)
        }
        .padding(.bottom, 16)
    }

    var body: some View {
        Group {
            if isLandscapeOrientation {
                GeometryReader { geometry in
                    HStack {
                        clothingImage
                            .frame(width: geometry.size.width / 3)
                            .padding(.vertical)

                        ScrollView {
                            clothingInformationView
                                .padding(.vertical)
                                .padding(.trailing, 40)
                        }
                    }
                }
            } else {
                ScrollView {
                    clothingImage
                    clothingInformationView
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(clothing.name)
        .onReceive(orientation, perform: handleOrientationChange)
        .sheet(isPresented: $isClothingFormVisible) { ClothingFormScreen(clothing: clothing) }
        .toolbar {
            Button(action: { isClothingFormVisible = true }) {
                Label("Edit clothing item", systemImage: "pencil.circle")
            }
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
