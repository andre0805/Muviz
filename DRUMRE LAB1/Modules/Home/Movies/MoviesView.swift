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
                .isLoading(viewModel.output.isLoading)

            Spacer()
        }
        .background(Color.backgroundColor)
        .navigationBarColor(backgroundColor: Color.backgroundColor, titleColor: Color.blackPrimary)
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
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    genreButton(for: nil, in: proxy)
                        .id("all")

                    ForEach(viewModel.output.genres, id: \.name) { genre in
                        genreButton(for: genre, in: proxy)
                            .id(genre.name)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    var movieList: some View {
        MovieList(movies: viewModel.output.movies) { movie in
            viewModel.input.movieTapped.send(movie)
        } onLoadMore: {
            viewModel.input.loadMoreMovies.send(())
        }
    }

    @ViewBuilder
    func genreButton(for genre: Genre?, in scrollProxy: ScrollViewProxy) -> some View {
        let isSelected = viewModel.output.selectedGenre == genre
        let backgroundColor = isSelected ? Color.whitePrimary : Color.blackPrimary
        let foregroundColor = isSelected ? Color.backgroundColor : Color.whitePrimary

        Button(genre?.name.uppercased() ?? "ALL") {
            viewModel.input.selectGenreTapped.send(genre)
            withAnimation {
                scrollProxy.scrollTo(genre?.name ?? "all", anchor: .center)
            }
        }
        .font(.system(size: 14, weight: .bold))
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(backgroundColor)
        .foregroundStyle(foregroundColor)
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
                .foregroundStyle(Color.whitePrimary)
                .background(Color.blackPrimary)
        }
        .clipShape(Circle())
    }
}

#Preview {
    NavigationStack {
        MoviesView {
            MoviesViewModel(
                moviesRouter: MoviesRouter(),
                moviesRepository: MoviesRepository(moviesApi: MoviesAPIMock()),
                sessionManager: .shared
            )
        }
    }
}
