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
    let onLoadMore: (() -> Void)?

    init(movies: [Movie], onTap: ((Movie) -> Void)?, onLoadMore: (() -> Void)? = nil) {
        self.movies = movies
        self.onTap = onTap
        self.onLoadMore = onLoadMore
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(movies, id: \.id) { movie in
                    movieView(for: movie)
                        .onAppear {
                            if shouldLoadMore(movie) { onLoadMore?() }
                        }
                }
            }
            .padding()
        }
        .background(Color.backgroundColor)
    }

    private func shouldLoadMore(_ movie: Movie) -> Bool {
        guard let index = movies.firstIndex(of: movie) else { return false }
        return index > movies.count - 5
    }
}

// MARK: Views
private extension MovieList {
    @ViewBuilder
    func movieView(for movie: Movie) -> some View {
        Button {
            onTap?(movie)
        } label: {
            HStack(spacing: 16) {
                movieImage(for: movie)
                movieInfo(for: movie)
                chevron
            }
            .frame(height: 100)
            .padding(.horizontal)
            .padding(.vertical, 24)
            .foregroundStyle(Color.whitePrimary)
        }
        .highlightColor(highlightColor: Color.gray.opacity(0.2))
        .background(Color.blackPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.shadow, radius: 4, y: 2)
    }

    @ViewBuilder
    func movieImage(for movie: Movie) -> some View {
        AsyncImage(url: URL(string: movie.posterUrl)) { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        } placeholder: {
            ProgressView()
        }
        .frame(width: 70, height: 100)
    }

    @ViewBuilder
    func movieInfo(for movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
                .font(.system(size: 22, weight: .medium))

            Text(movie.description)
                .font(.system(size: 14, weight: .light))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    var chevron: some View {
        Image(systemName: "chevron.right")
            .resizable()
            .scaledToFit()
            .frame(width: 16, height: 16)
    }
}

#Preview {
    MovieList(movies: .mock, onTap: nil, onLoadMore: nil)
}
