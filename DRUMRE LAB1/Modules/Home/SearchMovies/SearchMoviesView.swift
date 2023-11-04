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
        VStack {
            if viewModel.output.noMoviesFound {
                Text("Sorry, we can't find the movie you are looking for 😔")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
            } else {
                MovieList(movies: viewModel.output.movies) { movie in
                    viewModel.input.movieTapped.send(movie)
                }
                .isLoading(viewModel.output.isLoading)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, -16)
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search movies...")
        .navigationTitle(viewModel.output.title)
        .toolbar {
            toolbarView
        }
        .onChange(of: searchText) { _, newValue in
            guard newValue.count > 3 else { return }
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
                .foregroundStyle(.white)
                .background(.blue)
        }
        .clipShape(Circle())
    }
}

#Preview {
    NavigationStack {
        SearchMoviesView {
            SearchMoviesViewModel(
                searchRouter: SearchRouter(),
                searchMoviesRepository: SearchMoviesRepository(omdb: OMDBMock()),
                sessionManager: .shared
            )
        }
    }
}
