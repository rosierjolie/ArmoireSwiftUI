//
// CanvasScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/14/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SpriteKit
import SwiftUI

struct CanvasScreen: View {
    @StateObject private var viewModel = CanvasViewModel()
    @State private var isExitAlertVisible = false

    let scene = CanvasScene()

    var body: some View {
        NavigationView {
            ZStack {
                SpriteView(scene: scene)
            }
            .alert("Exit", isPresented: $isExitAlertVisible) {
                Button("Cancel", role: .cancel, action: {})
                Button("Exit", action: {})
            } message: {
                Text("Are you sure you want to close this runway? All progress will be saved.")
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Evening Outfit 2021")
            .toolbar {
                CanvasToolbar(viewModel: viewModel)

                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: { isExitAlertVisible = true }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct CanvasScreenPreviews: PreviewProvider {
    static var previews: some View {
        CanvasScreen()
    }
}
