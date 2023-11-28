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
    @Published var output: Output

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
        var errorMessage: String?

        var isAlertPresented: Bool {
            get { errorMessage != nil }
            set { if !newValue { errorMessage = nil } }
        }
    }
}

// MARK: Bind Input
private extension MovieDetailsViewModel {
    func bindInput() {
        bindUpdateFavoriteMovieTapped()
    }

    func bindUpdateFavoriteMovieTapped() {
        input.updateFavoriteMovieTapped
            .receive(on: DispatchQueueFactory.background)
            .flatMap { [unowned self] _ in
                setFavorite(isFavorite)
            }
            .receive(on: DispatchQueueFactory.main)
            .sink { [unowned self] success in
                withAnimation {
                    if success {
                        output.isFavorite.toggle()
                    } else {
                        output.errorMessage = "Failed to update favorite movie"
                    }
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

    func setFavorite(_ isFavorite: Bool) -> AnyPublisher<Bool, Never> {
        Future { [unowned self] promise in
            Task {
                do {
                    if isFavorite {
                        try await movieDetailsRepository.removeMovieFromFavorites(movie)
                    } else {
                        try await movieDetailsRepository.addMovieToFavorites(movie)
                    }
                    promise(.success(true))
                } catch {
                    log.error(error)
                    promise(.success(false))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
