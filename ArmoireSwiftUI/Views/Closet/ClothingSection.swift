//
// ClothingSection.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct ClothingSection: View {
    var title: String

    var body: some View {
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
}

struct ClothingSectionPreviews: PreviewProvider {
    static var previews: some View {
        ClothingSection(title: "About")
    }
}
