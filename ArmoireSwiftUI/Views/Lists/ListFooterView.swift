//
// ListFooterView.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct ListFooterView: View {
    var itemName: String
    var count: Int

    var body: some View {
        HStack {
            Spacer()

            Text("\(count) \(itemName)\(count == 1 ? "" : "s")")
                .systemScaledFont(size: 18, weight: .medium)
                .foregroundColor(.secondary)

            Spacer()
        }
        .listRowSeparator(.hidden)
        .padding(.vertical, 30)
    }
}

struct ListFooterViewPreviews: PreviewProvider {
    static var previews: some View {
        ListFooterView(itemName: "Folder", count: 4)
    }
}
