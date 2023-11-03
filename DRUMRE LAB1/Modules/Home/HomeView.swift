//
//  DRUMRE LAB1
//  HomeView.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    init(_ viewModel: @escaping () -> HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.output.isLoading {
                ProgressView()
            } else {
                genreList
                movieList
                Spacer()
            }
        }
        .padding(.horizontal)
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
private extension HomeView {
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

    var movieList: some View {
        List(viewModel.output.movies, id: \.id) { movie in
            movieView(for: movie)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .padding(.horizontal, -20)
    }

    @ViewBuilder
    func movieView(for movie: Movie) -> some View {
        Button {
            viewModel.input.movieTapped.send(movie)
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
        }
        .buttonStyle(.plain)
    }

    var toolbarView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.input.userButtonTapped.send()
            } label: {
                let imageUrl = URL(string: viewModel.output.user?.imageUrl ?? "")
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .frame(width: 32, height: 32)
                } placeholder: {
                    let initials = viewModel.output.user?.name
                        .split(separator: " ")
                        .compactMap { $0.first}
                        .map { String($0) }
                        .joined()

                    Text(initials ?? "ME")
                        .font(.system(size: 16))
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(.blue)
                }
                .clipShape(Circle())
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView {
            HomeViewModel(
                router: HomeRouter(),
                homeRepository: HomeRepository(
                    sessionManager: .shared,
                    database: .shared,
                    theMovieDB: TheMovieDB()
                )
            )
        }
    }
}

