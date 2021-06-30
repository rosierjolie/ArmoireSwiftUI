//
// DescriptionScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/29/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct DescriptionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextEditorActive: Bool
    @Binding var text: String

    var body: some View {
        VStack {
            TextEditor(text: $text)
                .focused($isTextEditorActive)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Enter Description")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isTextEditorActive = false }) {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
    }
}

struct DescriptionScreenPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DescriptionScreen(text: .constant(""))
        }
    }
}
