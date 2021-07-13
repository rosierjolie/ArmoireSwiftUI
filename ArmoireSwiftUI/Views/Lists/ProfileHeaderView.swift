//
// ProfileHeaderView.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/19/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Kingfisher
import SwiftUI

struct ProfileHeaderView: View {
    var user: User

    var body: some View {
        HStack {
            Spacer()

            VStack {
                KFImage(user.avatarUrl)
                    .resizable()
                    .placeholder {
                        Image("Placeholder")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    }
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(.lightGray), lineWidth: 1))

                Text(user.username)
                    .systemScaledFont(size: 30, weight: .bold)
                    .foregroundColor(.primary)
                    .textCase(.lowercase)

                Text(user.email)
                    .systemScaledFont(size: 20, weight: .medium)
                    .foregroundColor(.secondary)
                    .textCase(.lowercase)
            }
            .padding(.vertical, 20)

            Spacer()
        }
    }
}

struct ProfileHeaderViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(user: .example)
            .previewLayout(.sizeThatFits)
    }
}
