//
//  DRUMRE LAB1
//  MovieDetailsRepository.swift
//
//  Andre Flego
//

import Foundation

protocol MovieDetailsRepositoryProtocol {
    var sessionManager: SessionManager { get }
    var database: Database { get }

    func addMovieToFavorites(_ movie: Movie)
    func removeMovieFromFavorites(_ movie: Movie)
}

class MovieDetailsRepository: MovieDetailsRepositoryProtocol {
    let sessionManager: SessionManager
    let database: Database

    init(
        sessionManager: SessionManager,
        database: Database
    ) {
        self.sessionManager = sessionManager
        self.database = database
    }

    func addMovieToFavorites(_ movie: Movie) {
        sessionManager.currentUser!.addMovieToFavorites(movie)
        database.updateUser(sessionManager.currentUser!)
    }

    func removeMovieFromFavorites(_ movie: Movie) {
        sessionManager.currentUser!.removeMovieFromFavorites(movie)
        database.updateUser(sessionManager.currentUser!)
    }
}
