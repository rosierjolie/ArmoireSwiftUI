//
// AMNavButton.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/29/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct AMNavButton<Destination>: View where Destination: View {
    var title: String
    var destination: Destination

    init(title: String, @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.destination = destination()
    }

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)

                Image(systemName: "chevron.right")
                    .font(.body.bold())
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.vertical)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .foregroundColor(Color(.label))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray3), lineWidth: 2)
            )
        }
    }
}

struct AMNavButtonPreviews: PreviewProvider {
    static var previews: some View {
        AMNavButton(title: "Click Me") {
            Text("Hello!")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
