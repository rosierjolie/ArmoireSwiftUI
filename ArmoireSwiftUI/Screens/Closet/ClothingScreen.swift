//
// ClothingScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Kingfisher
import SwiftUI

struct ClothingScreen: View {
    @EnvironmentObject private var imageViewerStore: ImageViewerStore

    @State private var clothing: Clothing
    @State private var clothingImage: UIImage? = nil
    @State private var isClothingFormVisible = false
    @State private var isLandscapeOrientation = UIDevice.current.orientation.isLandscape

    let orientation = NotificationCenter.default
        .publisher(for: UIDevice.orientationDidChangeNotification)
        .map { _ in UIDevice.current.orientation }

    // MARK: - Methods

    init(clothing: Clothing) {
        _clothing = State(initialValue: clothing)
    }

    private func configureClothingImage() async {
        guard let clothingImageUrl = clothing.imageUrl else { return }

        do {
            let data = try Data(contentsOf: clothingImageUrl)
            clothingImage = UIImage(data: data)
        } catch {
            imageViewerStore.alertItem = .init(errorMessage: error.localizedDescription)
        }
    }

    private func handleOrientationChange(_ orientation: UIDeviceOrientation) {
        isLandscapeOrientation = UIDevice.current.orientation.isLandscape
    }

    private func presentImageViewer() {
        withAnimation {
            imageViewerStore.tappedImage = clothingImage
        }
    }

    // MARK: - Views

    private func clothingSection(title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Rectangle()
                .fill(Color.separator)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 1)

            Text(title)
                .systemScaledFont(size: 18, weight: .medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)

            Rectangle()
                .fill(Color.separator)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 1)
        }
    }

    private func clothingInfoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .fontWeight(.medium)

            Spacer()

            Text(value)
        }
        .systemScaledFont(size: 16)
    }

    @ViewBuilder private var clothingImageView: some View {
        Group {
            if isLandscapeOrientation {
                KFImage(clothing.imageUrl)
                    .resizable()
                    .loadImmediately()
                    .placeholder { ProgressView("Loading image") }
                    .scaledToFit()
            } else {
                KFImage(clothing.imageUrl)
                    .resizable()
                    .loadImmediately()
                    .placeholder {
                        Image("Placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipped()
                    }
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: presentImageViewer)
    }

    // MARK: Clothing info view

    private var clothingInformationView: some View {
        LazyVStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(clothing.name)
                        .systemScaledFont(size: 36, weight: .medium)
                        .foregroundColor(.accentColor)

                    Spacer()

                    ColorPicker("Color", selection: .constant(Color(hex: clothing.color)))
                        .labelsHidden()
                        .disabled(true)
                }

                Text(clothing.brand)
                    .systemScaledFont(size: 24, weight: .medium)
            }
            .padding(.horizontal, 12)

            clothingSection(title: "About")

            HStack {
                Text(clothing.description ?? "No description.")
                    .systemScaledFont(size: 14)
                    .padding(.horizontal, 12)

                Spacer()
            }

            clothingSection(title: "Info")

            VStack(spacing: 16) {
                clothingInfoRow(title: "Quantity", value: "\(clothing.quantity)")

                clothingInfoRow(title: "Size", value: clothing.size ?? "N/a")

                clothingInfoRow(title: "Material", value: clothing.material ?? "N/a")
            }
            .systemScaledFont(size: 16, weight: .medium)
            .padding(.horizontal, 12)

            clothingSection(title: "URL")

            HStack {
                if let clothingUrl = clothing.url, let url = URL(string: clothingUrl) {
                    Link(clothingUrl, destination: url)
                        .foregroundColor(Color(.systemTeal))
                } else {
                    Text("No URL available")
                        .foregroundColor(.red)

                    Spacer()
                }
            }
            .padding(.horizontal, 12)

            HStack {
                Text("Created on \(clothing.dateCreated.convertToShortFormat())")

                Spacer()

                if let dateUpdated = clothing.dateUpdated {
                    Text("Updated on \(dateUpdated.convertToShortFormat())")
                }
            }
            .foregroundColor(Color(.systemGray))
            .padding(.horizontal, 12)
        }
        .padding(.bottom, 10)
    }

    // MARK: - Body

    var body: some View {
        Group {
            if isLandscapeOrientation {
                GeometryReader { geometry in
                    HStack {
                        clothingImageView
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
                    clothingImageView
                    clothingInformationView
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(clothing.name)
        .onReceive(orientation, perform: handleOrientationChange)
        .sheet(isPresented: $isClothingFormVisible) {
            ClothingFormScreen(clothing: clothing) { clothing in
                print(clothing)
            }
        }
        .task(configureClothingImage)
        .toolbar {
            Button(action: { isClothingFormVisible = true }) {
                Label("Edit clothing", systemImage: "pencil.circle")
            }
        }
    }
}

// MARK: - Previews

struct ClothingScreenPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ClothingScreen(clothing: .example)
        }
        .navigationViewStyle(.stack)
    }
}
