//
// Alerts.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text

    init(errorMessage: String) {
        self.title = Text("Error")
        self.message = Text(errorMessage)
        self.buttonTitle = Text("Okay")
    }

    init(title: String, message: String, buttonTitle: String) {
        self.title = Text(title)
        self.message = Text(message)
        self.buttonTitle = Text(buttonTitle)
    }
}
