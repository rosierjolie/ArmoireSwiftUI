//
// AboutScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct AboutScreen: View {
    var body: some View {
        VStack {
            Text("About Screen")
        }
        .navigationTitle("About")
    }
}

struct AboutScreenPreviews: PreviewProvider {
    static var previews: some View {
        AboutScreen()
    }
}
