//
// RunwayScreen.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct RunwayScreen: View {
    @State private var runways: [Runway] = [
        .init(id: UUID().uuidString, title: "My Runway 1", isSharing: true),
        .init(id: UUID().uuidString, title: "Evening Outfit", isSharing: true),
        .init(id: UUID().uuidString, title: "My Runway 2", isSharing: false),
        .init(id: UUID().uuidString, title: "Wedding day", isSharing: true),
        .init(id: UUID().uuidString, title: "My Runway 3", isSharing: false),
        .init(id: UUID().uuidString, title: "My Runway 4", isSharing: false),
        .init(id: UUID().uuidString, title: "Everyday look", isSharing: true),
        .init(id: UUID().uuidString, title: "My Runway 5", isSharing: false),
    ]
    @State private var searchText = ""

    private var columns: [GridItem] = [
        .init(.adaptive(minimum: 140), spacing: 20)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(runways, id: \.id) { runway in
                    RunwayCell(runway: runway)
                }
            }
            .padding([.horizontal, .bottom], 20)
        }
        .navigationTitle("Runway")
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search Runways"
        )
        .toolbar {
            Button(action: {}) {
                Label("Create runway", systemImage: "plus.circle")
            }
        }
    }
}

struct RunwayScreenPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RunwayScreen()
        }
        .navigationViewStyle(.stack)
    }
}
