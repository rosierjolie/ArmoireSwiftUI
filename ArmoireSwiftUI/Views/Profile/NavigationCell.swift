//
// NavigationCell.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/19/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct NavigationCell<Destination>: View where Destination: View {
    var title: String
    var subtitle: String
    var destination: () -> Destination

    init(title: String, subtitle: String, @ViewBuilder destination: @escaping () -> Destination) {
        self.title = title
        self.subtitle = subtitle
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: Text("Change Username")) {
            HStack {
                Text(title)

                Spacer()

                Text(subtitle)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct NavigationCellPreviews: PreviewProvider {
    static var previews: some View {
        NavigationCell(title: "Username", subtitle: "rosierjolie") {
            Text("Hello")
        }
    }
}
