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
        .alert(
            "Oops! Something went wrong...",
            isPresented: $viewModel.output.isAlertPresented,
            actions: { Button("OK", role: .cancel, action: { }) },
            message: { Text(viewModel.output.errorMessage ?? "") }
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarView
        }
        .navigationBarColor(backgroundColor: Color.backgroundColor, titleColor: Color.blackPrimary)
        .background(Color.backgroundColor)
    }
}

// MARK: Views
private extension MovieDetailsView {
    var posterView: some View {
        AsyncImage(url: URL(string: movie.posterUrl)) { image in
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
                VStack(alignment: .leading, spacing: 6) {
                    title
                    rating
                }
                plot
                genres
                year
                languages
                director
                actors
                duration
            }
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.backgroundColor)
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

    var rating: some View {
        RatingView(rating: (movie.rating ?? 0) / 2, total: 5)
    }

    var plot: some View {
        movieDetailView(
            title: "Plot",
            value: movie.description
        )
        .lineSpacing(4)
    }

    var genres: some View {
        movieDetailView(
            title: "Genres",
            value: movie.genres.map { $0.name }.joined(separator: ", ")
        )
    }

    var year: some View {
        movieDetailView(
            title: "Year",
            value: movie.getYear()
        )
    }

    var languages: some View {
        movieDetailView(
            title: "Languages",
            value: movie.languages.joined(separator: ", ")
        )
    }

    var director: some View {
        movieDetailView(title: "Director", value: movie.director)
    }

    var actors: some View {
        movieDetailView(title: "Actors", value: movie.actors.joined(separator: ", "))
    }

    @ViewBuilder
    var duration: some View {
        if let duration = movie.duration {
            movieDetailView(title: "Duration", value: "\(duration) min")
        } else {
            movieDetailView(title: "Duration", value: "N/A")
        }
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
                    .renderingMode(.template)
                    .foregroundStyle(Color.blackPrimary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailsView {
            MovieDetailsViewModel(
                movie: .mock,
                movieDetailsRepository: MovieDetailsRepository(
                    sessionManager: .shared,
                    moviesApi: MoviesAPIMock()
                )
            )
        }
    }
}
