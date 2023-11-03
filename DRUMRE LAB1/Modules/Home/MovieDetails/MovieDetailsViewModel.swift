//
//  DRUMRE LAB1
//  MovieDetailsViewModel.swift
//
//  Andre Flego
//

import Foundation
import Combine
import SwiftUI

class MovieDetailsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    let input = Input()
    @Published private(set) var output: Output

    private let movie: Movie
    private let movieDetailsRepository: MovieDetailsRepositoryProtocol
    private let sessionManager = SessionManager.shared

    init(
        movie: Movie,
        movieDetailsRepository: MovieDetailsRepositoryProtocol
    ) {
        self.movie = movie
        self.movieDetailsRepository = movieDetailsRepository

        self.output = Output(
            movie: movie,
            isFavorite: sessionManager.currentUser?.favoriteMovies.contains { $0 == movie } ?? false
        )

        bindInput()
    }
}

// MARK: Input & Output
extension MovieDetailsViewModel {
    struct Input {
        let updateFavoriteMovieTapped = PassthroughSubject<Void, Never>()
    }

    struct Output {
        let movie: Movie
        var isFavorite: Bool
    }
}

// MARK: Bind Input
private extension MovieDetailsViewModel {
    func bindInput() {
        bindUpdateFavoriteMovieTapped()
    }

    func bindUpdateFavoriteMovieTapped() {
        input.updateFavoriteMovieTapped
            .sink { [unowned self] _ in
                withAnimation {
                    output.isFavorite.toggle()
                }

                if isFavorite {
                    movieDetailsRepository.removeMovieFromFavorites(movie)
                } else {
                    movieDetailsRepository.addMovieToFavorites(movie)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension MovieDetailsViewModel {
    var isFavorite: Bool {
        guard let favoriteMovies = sessionManager.currentUser?.favoriteMovies else {
            return false
        }
        return favoriteMovies.contains(where: { $0 == movie })
    }
}
