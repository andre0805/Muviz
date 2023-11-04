//
//  DRUMRE LAB1
//  SearchMoviesRepository.swift
//
//  Andre Flego
//

import Foundation

protocol SearchMoviesRepositoryProtocol {
    var omdb: OMDBProtocol { get }

    func searchMovies(_ searchQuery: String) async throws -> [Movie]
}

class SearchMoviesRepository: SearchMoviesRepositoryProtocol {
    let omdb: OMDBProtocol

    init(omdb: OMDBProtocol) {
        self.omdb = omdb
    }

    func searchMovies(_ searchQuery: String) async throws -> [Movie] {
        return try await omdb.searchMovies(searchQuery).mapToDomainModel()
    }
}
