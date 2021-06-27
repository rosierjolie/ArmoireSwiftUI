//
// View+Ext.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct SystemScaledFont: ViewModifier {
    var size: CGFloat
    var weight: Font.Weight

    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.system(size: scaledSize, weight: weight))
    }
}

extension View {
    func systemScaledFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.modifier(SystemScaledFont(size: size, weight: weight))
    }
}
