//
//  DRUMRE LAB1
//  MoviesView.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

struct MoviesView: View {
    @StateObject private var viewModel: MoviesViewModel

    init(_ viewModel: @escaping () -> MoviesViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack(spacing: 16) {
            genreList
                .padding(.horizontal)
                .transition(.move(edge: .leading))

            movieList
                .transition(.move(edge: .bottom))

            Spacer()
        }
        .padding(.bottom, -16)
        .isLoading(viewModel.output.isLoading)
        .navigationTitle(viewModel.output.title)
        .toolbar {
            toolbarView
        }
        .onAppear {
            viewModel.input.viewDidAppear.send()
        }
    }
}

// MARK: Views
private extension MoviesView {
    var genreList: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                genreButton(for: nil)

                ForEach(viewModel.output.genres, id: \.name) { genre in
                    genreButton(for: genre)
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    var movieList: some View {
        MovieList(movies: viewModel.output.movies) { movie in
            viewModel.input.movieTapped.send(movie)
        }
    }

    @ViewBuilder
    func genreButton(for genre: Genre?) -> some View {
        let isSelected = viewModel.output.selectedGenre == genre

        Button(genre?.name.uppercased() ?? "ALL") {
            viewModel.input.selectGenreTapped.send(genre)
        }
        .font(.system(size: 14, weight: .bold))
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(Color.blue.opacity(isSelected ? 1 : 0.5))
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    var toolbarView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.input.userButtonTapped.send()
            } label: {
                profileImage
            }
        }
    }

    @ViewBuilder
    var profileImage: some View {
        let imageUrl = URL(string: viewModel.output.user.imageUrl ?? "")

        AsyncImage(url: imageUrl) { image in
            image
                .resizable()
                .frame(width: 32, height: 32)
        } placeholder: {
            let initials = viewModel.output.user.name
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

#Preview {
    NavigationStack {
        MoviesView {
            MoviesViewModel(
                moviesRouter: MoviesRouter(),
                moviesRepository: MoviesRepository(theMovieDB: TheMovieDBMock()),
                sessionManager: .shared
            )
        }
    }
}
