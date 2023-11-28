//
//  DRUMRE LAB1
//  MoviesRepository.swift
//
//  Andre Flego
//

import Foundation

protocol MoviesRepositoryProtocol {
    var moviesApi: any MoviesAPIProtocol { get }

    func getGenres() async throws -> [Genre]
    func getMovies(lastTitle: String?) async throws -> [Movie]
}

class MoviesRepository: MoviesRepositoryProtocol {
    let moviesApi: any MoviesAPIProtocol

    init(moviesApi: any MoviesAPIProtocol) {
        self.moviesApi = moviesApi
    }

    func getGenres() async throws -> [Genre] {
        return try await moviesApi.getGenres()
    }

    func getMovies(lastTitle: String? = nil) async throws -> [Movie] {
        return try await moviesApi.getMovies(lastTitle: lastTitle)
    }
}
