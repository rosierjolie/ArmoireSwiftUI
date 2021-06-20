//
// AMTextField.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct AMTextField: View {
    @State private var fieldIsSecure = false

    var placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    func isSecure() -> some View {
        var view = self
        view._fieldIsSecure = State(initialValue: true)
        return view
    }

    var body: some View {
        Group {
            if fieldIsSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .tint(.accentColor)
    }
}

struct AMTextFieldPreviews: PreviewProvider {
    static var previews: some View {
        AMTextField("Email", text: .constant(""))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
