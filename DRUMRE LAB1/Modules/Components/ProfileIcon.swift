//
//  DRUMRE LAB1
//  ProfileIcon.swift
//
//  Andre Flego
//

import SwiftUI

struct ProfileIcon: View {
    let user: User

    var body: some View {
        let imageUrl = URL(string: user.imageUrl ?? "")

        AsyncImage(url: imageUrl) { image in
            image
                .resizable()
        } placeholder: {
            let initials = user.name
                .split(separator: " ")
                .compactMap { $0.first}
                .map { String($0) }
                .joined()

            Text(initials)
                .font(.system(size: 16))
                .padding(8)
                .foregroundStyle(.white)
                .background(.blue)
        }
        .clipShape(Circle())
    }
}
