//
// RunwayCell.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 7/9/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct RunwayCell: View {
    var runway: Runway

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("Runway Snapshot")
                .resizable()
                .scaledToFit()
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray4))
                )
                .padding(.bottom, 12)

            Text(runway.title)
                .font(.headline)
                .padding(.bottom, 4)

            HStack {
                Image(systemName: "circle.fill")
                    .font(.caption)
                    .foregroundColor(runway.isSharing ? .green : .red)

                Text(runway.isSharing ? "Sharing" : "Not Sharing")

                Spacer()
            }
        }
        .background(Color(.systemBackground))
        .contextMenu {
            Button("Delete runway", role: .destructive, action: {})
        }
    }
}

struct RunwayCellPreviews: PreviewProvider {
    static var previews: some View {
        RunwayCell(runway: .example)
            .previewLayout(.sizeThatFits)
            .frame(width: 200)
            .padding()
    }
}
