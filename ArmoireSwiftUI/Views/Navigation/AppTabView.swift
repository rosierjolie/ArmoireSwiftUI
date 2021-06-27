//
// AppTabView.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

final class ImageViewerStore: ObservableObject {
    @Published var tappedImage: UIImage?
}

struct AppTabView: View {
    @StateObject private var imageViewerStore = ImageViewerStore()
    @State private var selectedTab: Tab = .closet

    enum Tab { case closet, runway, profile }

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                NavigationView {
                    ClosetScreen()
                }
                .tabItem {
                    Label("Closet", systemImage: "folder")
                        .symbolVariant(selectedTab == .closet ? .fill : .slash)
                }
                .tag(Tab.closet)

                NavigationView {
                    RunwayScreen()
                }
                .tabItem {
                    Label("Runway", systemImage: "binoculars")
                        .symbolVariant(selectedTab == .runway ? .fill : .slash)
                }
                .tag(Tab.runway)

                NavigationView {
                    ProfileScreen()
                }
                .tabItem {
                    Label("Profile", systemImage: "person")
                        .symbolVariant(selectedTab == .profile ? .fill : .slash)
                }
                .tag(Tab.profile)
            }
            .environmentObject(imageViewerStore)

            if let tappedImage = imageViewerStore.tappedImage {
                ImageViewerScreen(image: tappedImage)
                    .environmentObject(imageViewerStore)
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct AppTabViewPreviews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
