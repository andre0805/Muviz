//
//  DRUMRE LAB1
//  MoviesRepository.swift
//
//  Andre Flego
//

import Foundation

protocol MoviesRepositoryProtocol {
    var theMovieDB: TheMovieDBProtocol { get }

    func getGenres() async throws -> [Genre]
    func getMovies(page: Int) async throws -> [Movie]
}

class MoviesRepository: MoviesRepositoryProtocol {
    let theMovieDB: TheMovieDBProtocol

    init(theMovieDB: TheMovieDBProtocol) {
        self.theMovieDB = theMovieDB
    }

    func getGenres() async throws -> [Genre] {
        var genres: [Genre] = []

        let theMovieDBGenres = try await getGenresFromTheMovieDB()
        genres.append(contentsOf: theMovieDBGenres)

        return genres
    }

    func getMovies(page: Int = 1) async throws -> [Movie] {
        var movies: [Movie] = []

        let theMovieDBMovies = try await getMoviesFromTheMovieDB(page: page)
        movies.append(contentsOf: theMovieDBMovies)

        return movies
    }
}

// MARK: The Movie DB
private extension MoviesRepository {
    func getGenresFromTheMovieDB() async throws -> [Genre] {
        return try await theMovieDB.getGenres().mapToDomainModel()
    }

    func getMoviesFromTheMovieDB(page: Int = 1) async throws -> [Movie] {
        return try await theMovieDB.getMovies(page: page).mapToDomainModel(withGenres: theMovieDB.cachedGenres)
    }
}
