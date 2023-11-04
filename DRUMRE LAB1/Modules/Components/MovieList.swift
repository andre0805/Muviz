//
//  DRUMRE LAB1
//  MovieList.swift
//
//  Andre Flego
//

import SwiftUI

struct MovieList: View {
    let movies: [Movie]
    let onTap: ((Movie) -> Void)?

    var body: some View {
        List(movies, id: \.id) { movie in
            movieView(for: movie)
                .listRowSeparator(.hidden)
                .padding(.vertical, -10)
        }
        .listStyle(.plain)
        .padding(.horizontal, -20)
    }

    @ViewBuilder
    private func movieView(for movie: Movie) -> some View {
        Button {
            onTap?(movie)
        } label: {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: movie.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 70, height: 100)

                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.system(size: 22, weight: .medium))

                    Text(movie.description)
                        .font(.system(size: 14, weight: .light))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                Image(.chevronRight)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            .frame(height: 100)
            .padding(16)
        }
        .highlightColor(highlightColor: Color.gray.opacity(0.2))
    }
}

#Preview {
    MovieList(movies: .mock, onTap: nil)
}
