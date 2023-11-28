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
                description
                genres
                year
                languages
                director
                actors
                duration
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.backgroundColor)
            .clipShape(
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, topTrailing: 10))
            )
            .padding(.top, 500)
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    var rating: some View {
        let rating = (movie.rating ?? 0) / 2
        let ratingString = rating != 0 ? "\(rating)" : "-"
        Label {
            Text("(\(ratingString))")
                .font(.system(size: 16))
        } icon: {
            HStack {
                let fullStars = Int(rating)
                let partialStar = rating - Float(fullStars)
                let emptyStars = 5 - fullStars - 1
                let size: CGFloat = 16

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

                // empty stars
                if emptyStars > 0 {
                    ForEach(0..<emptyStars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: size, height: size)
                    }
                    .foregroundStyle(.gray)
                }
            }
            .font(.system(size: 16, weight: .medium))
        }
    }

    var title: some View {
        Text(movie.title)
            .font(.largeTitle)
            .fontWeight(.bold)
    }

    var description: some View {
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

    @ViewBuilder
    var duration: some View {
        if let duration = movie.duration {
            movieDetailView(title: "Duration", value: "\(duration) min")
        } else {
            movieDetailView(title: "Duration", value: "N/A")
        }
    }

    var director: some View {
        movieDetailView(title: "Director", value: movie.director)
    }

    var actors: some View {
        movieDetailView(title: "Actors", value: movie.actors.joined(separator: ", "))
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
