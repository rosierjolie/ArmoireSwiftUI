//
// ImageViewerScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/23/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct ImageViewerScreen: View {
    @EnvironmentObject private var imageViewerStore: ImageViewerStore

    var image: UIImage?

    private func dismissImageViewer() {
        withAnimation {
            imageViewerStore.tappedImage = nil
        }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding(12)
            }
        }
        .onTapGesture(perform: dismissImageViewer)
        .zIndex(1)
    }
}

struct ImageViewerScreenPreviews: PreviewProvider {
    static var previews: some View {
        ImageViewerScreen(image: UIImage(named: "Dress Example"))
    }
}
