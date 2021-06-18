//
// FormToolbar.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct FormNavigationToolbar: ToolbarContent {
    var cancel: () -> Void
    var done: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel", action: cancel)
        }

        ToolbarItem(placement: .confirmationAction) {
            Button("Done", action: done)
        }
    }
}

struct FormKeyboardToolbar: ToolbarContent {
    var dismissAction: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            HStack {
                Spacer()

                Button(action: dismissAction) {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
    }
}
