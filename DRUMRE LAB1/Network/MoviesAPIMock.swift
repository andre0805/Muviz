//
//  DRUMRE LAB1
//  MoviesAPIMock.swift
//
//  Andre Flego
//

import Foundation

class MoviesAPIMock: MoviesAPIProtocol {
    func getGenres() async throws -> [Genre] {
        return [
            Genre(id: 1, name: "Action"),
            Genre(id: 2, name: "Comedy"),
            Genre(id: 3, name: "Drama"),
            Genre(id: 4, name: "Crimi"),
            Genre(id: 5, name: "Science Fiction and Fantasy"),
            Genre(id: 6, name: "Romance"),
            Genre(id: 7, name: "Mystery"),
            Genre(id: 8, name: "Documentary"),
            Genre(id: 9, name: "Animation"),
            Genre(id: 10, name: "Horror"),
        ]
    }

    func getMovies(lastTitle: String? = nil) async throws -> [Movie] {
        return .mock
    }

    func searchMovies(_ searchQuery: String, lastTitle: String?) async throws -> [Movie] {
        return [.mock]
    }

    func getUser(id: String) async throws -> User {
        return .mock
    }

    func createUser(_ user: User) async throws -> User {
        return user
    }

    func updateUser(_ user: User) async throws -> User {
        return user
    }
}
