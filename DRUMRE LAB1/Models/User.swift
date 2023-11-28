//
//  DRUMRE LAB1
//  User.swift
//
//  Andre Flego
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let imageUrl: String?
    var favoriteMovies: [Movie] = []

    init(id: String, name: String, email: String, imageUrl: String? = nil, favoriteMovies: [Movie] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.imageUrl = imageUrl
        self.favoriteMovies = favoriteMovies
    }
}

// MARK: Equatable
extension User: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.email == rhs.email &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.favoriteMovies == rhs.favoriteMovies
    }
}

// MARK: Favorite movies
extension User {
    mutating func addMovieToFavorites(_ movie: Movie) {
        favoriteMovies.append(movie)
    }

    mutating func removeMovieFromFavorites(_ movie: Movie) {
        favoriteMovies.removeAll(where: { $0 == movie })
    }
}

// MARK: Mocks
extension User {
    static let mock = User(
        id: "1",
        name: "Andre Flego",
        email: "andre.flego@fer.hr",
        imageUrl: "https://cdn-icons-png.flaticon.com/512/666/666201.png",
        favoriteMovies: .mock
    )
}
