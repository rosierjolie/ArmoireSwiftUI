//
// String+Ext.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/30/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Foundation

extension String {
    var blobCase: String {
        self.replacingOccurrences(of: " ", with: "-")
    }
}
