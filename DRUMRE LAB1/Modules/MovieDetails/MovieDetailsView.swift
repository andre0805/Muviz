//
//  DRUMRE LAB1
//  MovieDetailsView.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

struct MovieDetailsView: View {
    @StateObject private var viewModel: MovieDetailsViewModel

    init(_ viewModel: @escaping () -> MovieDetailsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var movie: Movie {
        viewModel.output.movie
    }

    var body: some View {
        ZStack {
            posterView
                .frame(maxHeight: .infinity, alignment: .top)

            details
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarView
        }
    }
}

// MARK: Views
private extension MovieDetailsView {
    var posterView: some View {
        AsyncImage(url: URL(string: movie.imageUrl)) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        } placeholder: {
            EmptyView()
        }
    }

    var details: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                title
                description
                genre
                year
                language
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .clipShape(
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, topTrailing: 10))
            )
            .padding(.top, 500)
        }
        .scrollIndicators(.hidden)
    }

    var title: some View {
        Text(movie.title)
            .font(.largeTitle)
            .fontWeight(.bold)
    }

    var description: some View {
        movieDetailView(
            title: "Description",
            value: movie.description
        )
        .lineSpacing(4)
    }

    var genre: some View {
        movieDetailView(
            title: "Genre",
            value: movie.genres.map { $0.name }.joined(separator: ", ")
        )
    }

    var year: some View {
        movieDetailView(
            title: "Year",
            value: String(movie.year)
        )
    }

    var language: some View {
        movieDetailView(
            title: "Language",
            value: movie.language
        )
    }

    @ViewBuilder
    func movieDetailView(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .fontWeight(.bold)

            Text(value)
        }
        .font(.system(size: 16))
    }

    var toolbarView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.input.updateFavoriteMovieTapped.send()
            } label: {
                Image(systemName: viewModel.output.isFavorite ? "star.fill" : "star")
            }
        }
    }
}

struct MovieDetailsPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MovieDetailsView {
                MovieDetailsViewModel(
                    movie: .mock,
                    movieDetailsRepository: MovieDetailsRepository(
                        sessionManager: .shared,
                        database: .shared
                    )
                )
            }
        }
    }
}

