//
//  DRUMRE LAB1
//  RatingView.swift
//
//  Andre Flego
//

import SwiftUI

struct RatingView: View {
    let rating: Double
    let total: Int

    let fillColor: Color
    let emptyColor: Color
    let size: CGFloat

    init(
        rating: Double,
        total: Int,
        fillColor: Color = .yellow,
        emptyColor: Color = .gray,
        size: CGFloat = 16
    ) {
        self.rating = min(rating, Double(total))
        self.total = total
        self.fillColor = fillColor
        self.emptyColor = emptyColor
        self.size = size
    }

    var body: some View {
        let ratingString = rating != 0 ? "\(rating)" : "-"

        Label {
            Text("(\(ratingString))")
                .font(.system(size: size))
        } icon: {
            HStack {
                let fullStars = Int(rating)
                let partialStar = rating - Double(fullStars)
                let emptyStars = total

                ZStack(alignment: .leading) {
                    // empty stars
                    HStack {
                        ForEach(0..<emptyStars, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: size, height: size)
                        }
                        .foregroundStyle(.gray)
                    }

                    HStack {
                        // full stars
                        if fullStars > 0 {
                            ForEach(0..<fullStars, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: size, height: size)
                            }
                            .foregroundStyle(.yellow)
                        }

                        // partial star
                        if partialStar > 0 {
                            Rectangle()
                                .foregroundStyle(.gray)
                                .overlay(alignment: .leading) {
                                    Rectangle()
                                        .foregroundStyle(.yellow)
                                        .frame(width: size * CGFloat(partialStar), height: size)
                                }
                                .frame(width: size, height: size)
                                .mask {
                                    Image(systemName: "star.fill")
                                        .resizable()
                                }
                        }
                    }

                }
            }
        }
    }
}

#Preview {
    RatingView(rating: 3.6, total: 5, size: 20)
}
