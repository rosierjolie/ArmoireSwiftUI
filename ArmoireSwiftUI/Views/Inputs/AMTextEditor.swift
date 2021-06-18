//
// AMTextEditor.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct AMTextEditor: View {
    var placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        ZStack {
            TextEditor(text: $text)
                .tint(.accentColor)

            if text.isEmpty {
                HStack {
                    Text(placeholder)
                        .foregroundColor(.init(.systemGray2))

                    Spacer()
                }
                .background(Color(.systemGray5))
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }
}

struct AMTextEditorPreviews: PreviewProvider {
    static var previews: some View {
        AMTextEditor("Enter description", text: .constant(""))
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
