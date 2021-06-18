//
// View+Ext.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/18/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct ScaledFont: ViewModifier {
    var size: CGFloat

    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.system(size: scaledSize))
    }
}

struct HideDisclosureIndicator<DestinationView: View>: ViewModifier {
    var destination: DestinationView

    init(destination: @escaping () -> DestinationView) {
        self.destination = destination()
    }

    func body(content: Content) -> some View {
        ZStack {
            NavigationLink(destination: destination) {
                EmptyView()
            }
            .opacity(0)

            content
        }
    }
}

extension View {
    func scaledFont(size: CGFloat) -> some View {
        return self.modifier(ScaledFont(size: size))
    }

//    func hideDisclosureIndicator<DestinationView: View>(destination: DestinationView) -> some View {
//        return self.modifier(HideDisclosureIndicator<DestinationView>(destination: destination))
//    }
}
