//
// CanvasToolbar.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/14/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct CanvasToolbar: ToolbarContent {
    var viewModel: CanvasViewModel

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Menu {
                Button(action: {}) {
                    Label("Share runway", systemImage: "link")
                }

                Button(action: {}) {
                    Label("Add item", systemImage: "plus")
                }
            } label: {
                Image(systemName: "ellipsis")
            }
        }

        ToolbarItemGroup(placement: .bottomBar) {
            Button(action: {}) {
                Image(systemName: "arrowshape.turn.up.left")
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "arrowshape.turn.up.right")
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "arrow.up")
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "arrow.down")
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "trash")
            }
        }
    }
}
