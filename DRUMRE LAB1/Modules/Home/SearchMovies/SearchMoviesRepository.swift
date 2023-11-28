//
//  DRUMRE LAB1
//  SearchMoviesRepository.swift
//
//  Andre Flego
//

import Foundation

protocol SearchMoviesRepositoryProtocol {
    var moviesApi:any  MoviesAPIProtocol { get }

    func searchMovies(_ searchQuery: String, lastTitle: String?) async throws -> [Movie]
}

class SearchMoviesRepository: SearchMoviesRepositoryProtocol {
    let moviesApi: any MoviesAPIProtocol

    init(moviesApi: any MoviesAPIProtocol) {
        self.moviesApi = moviesApi
    }

    func searchMovies(_ searchQuery: String, lastTitle: String? = nil) async throws -> [Movie] {
        return try await moviesApi.searchMovies(searchQuery, lastTitle: lastTitle)
    }
}
