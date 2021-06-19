//
// ProfileHeaderView.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/19/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import SwiftUI

struct ProfileHeaderView: View {
    var body: some View {
        HStack {
            Spacer()

            VStack {
                AsyncImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b5/191125_Taylor_Swift_at_the_2019_American_Music_Awards_%28cropped%29.png")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(.greatestFiniteMagnitude)
                } placeholder: {
                    Image("Placeholder")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(.greatestFiniteMagnitude)
                }

                Text("@rosierjolie")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.primary)
                    .textCase(.lowercase)

                Text("rosierjolie@gmail.com")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .textCase(.lowercase)
            }
            .padding(.vertical, 20)

            Spacer()
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView()
    }
}
