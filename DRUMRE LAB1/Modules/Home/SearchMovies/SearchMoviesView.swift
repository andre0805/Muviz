//
//  DRUMRE LAB1
//  SearchMoviesView.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

struct SearchMoviesView: View {
    @StateObject private var viewModel: SearchMoviesViewModel

    @State private var searchText = ""

    init(_ viewModel: @escaping () -> SearchMoviesViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.output.noMoviesFound {
                Text("Sorry, we can't find the movie you are looking for 😔")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.customGray)
                    .frame(width: 300, alignment: .center)
                    .shadow(color: Color.customGray, radius: 6, y: 2)
            } else {
                MovieList(movies: viewModel.output.movies) { movie in
                    viewModel.input.movieTapped.send(movie)
                } onLoadMore: {
                    viewModel.input.loadMoreMovies.send()
                }
                .isLoading(viewModel.output.isLoading)
            }

            Spacer()
        }
        .background(Color.backgroundColor)
        .searchable(text: $searchText, prompt: "Search movies...")
        .searchBarColor(tintColor: .blackPrimary)
        .navigationBarColor(backgroundColor: Color.backgroundColor, titleColor: Color.blackPrimary)
        .navigationTitle(viewModel.output.title)
        .toolbar {
            toolbarView
        }
        .onChange(of: searchText) { _, newValue in
            viewModel.input.searchInput.send(newValue)
        }
    }
}

// MARK: Views
private extension SearchMoviesView {
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
        SearchMoviesView {
            SearchMoviesViewModel(
                searchRouter: SearchRouter(),
                searchMoviesRepository: SearchMoviesRepository(moviesApi: MoviesAPIMock()),
                sessionManager: .shared
            )
        }
    }
}
