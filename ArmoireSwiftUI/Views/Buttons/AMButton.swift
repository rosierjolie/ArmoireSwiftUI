//
// AMButton.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct AMButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .systemScaledFont(size: 20, weight: .semibold)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.vertical)
                .background(Color.accentColor)
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }
}

struct AMButtonPreviews: PreviewProvider {
    static var previews: some View {
        AMButton(title: "Click Me", action: {})
            .previewLayout(.sizeThatFits)
    }
}
