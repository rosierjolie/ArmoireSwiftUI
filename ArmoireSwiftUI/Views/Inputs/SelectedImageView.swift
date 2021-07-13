//
// SelectedImageView.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/23/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct SelectedImageView: View {
    var selectedImage: UIImage?

    var body: some View {
        if let selectedImage = selectedImage {
            HStack {
                Spacer()

                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 280)

                Spacer()
            }
        }
    }
}
