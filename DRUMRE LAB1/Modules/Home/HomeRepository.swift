//
//  DRUMRE LAB1
//  HomeRepository.swift
//
//  Andre Flego
//

import Combine

protocol HomeRepositoryProtocol {
    var sessionManager: SessionManager { get }
    var database: Database { get }
    var theMovieDB: TheMovieDBProtocol { get }

    func logout()
    func getGenres() async throws -> [Genre]
    func getMovies(page: Int) async throws -> [Movie]
}

class HomeRepository: HomeRepositoryProtocol {
    let sessionManager: SessionManager
    let database: Database
    let theMovieDB: TheMovieDBProtocol

    init(
        sessionManager: SessionManager,
        database: Database,
        theMovieDB: TheMovieDBProtocol
    ) {
        self.sessionManager = sessionManager
        self.database = database
        self.theMovieDB = theMovieDB
    }

    func logout() {
        sessionManager.logOut()
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
private extension HomeRepository {
    func getGenresFromTheMovieDB() async throws -> [Genre] {
        return try await theMovieDB.getGenres().mapToDomainModel()
    }

    func getMoviesFromTheMovieDB(page: Int = 1) async throws -> [Movie] {
        return try await theMovieDB.getMovies(page: page).mapToDomainModel(withGenres: theMovieDB.cachedGenres)
    }
}
