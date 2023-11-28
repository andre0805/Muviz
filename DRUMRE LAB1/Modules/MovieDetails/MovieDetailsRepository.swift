//
//  DRUMRE LAB1
//  MovieDetailsRepository.swift
//
//  Andre Flego
//

import Foundation

protocol MovieDetailsRepositoryProtocol {
    var sessionManager: SessionManager { get }
    var moviesApi: any MoviesAPIProtocol { get }

    func addMovieToFavorites(_ movie: Movie) async throws
    func removeMovieFromFavorites(_ movie: Movie) async throws
}

class MovieDetailsRepository: MovieDetailsRepositoryProtocol {
    let sessionManager: SessionManager
    var moviesApi: any MoviesAPIProtocol

    init(
        sessionManager: SessionManager,
        moviesApi: any MoviesAPIProtocol
    ) {
        self.sessionManager = sessionManager
        self.moviesApi = moviesApi
    }

    func addMovieToFavorites(_ movie: Movie) async throws {
        guard var user = sessionManager.currentUser else { return }
        user.addMovieToFavorites(movie)
        
        let updatedUser = try await moviesApi.updateUser(user)
        DispatchQueueFactory.main.async { [unowned self] in
            sessionManager.login(updatedUser)
        }
    }

    func removeMovieFromFavorites(_ movie: Movie) async throws {
        guard var user = sessionManager.currentUser else { return }
        user.removeMovieFromFavorites(movie)

        let updatedUser = try await moviesApi.updateUser(user)
        DispatchQueueFactory.main.async { [unowned self] in
            sessionManager.login(updatedUser)
        }
    }
}
