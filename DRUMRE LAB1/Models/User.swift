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

    init?(from data: [String: Any])  {
        guard
            let id = data["id"] as? String,
            let name = data["name"] as? String,
            let email = data["email"] as? String
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.email = email
        self.imageUrl = data["imageUrl"] as? String
        
        let favoriteMoviesData = data["favoriteMovies"] as? [[String: Any]] ?? []
        self.favoriteMovies = favoriteMoviesData.compactMap { Movie(from: $0) }
    }

    func toDictionary() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "email": email,
            "imageUrl": imageUrl ?? "",
            "favoriteMovies": favoriteMovies.map { $0.toDictionary() }
        ]
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
        favoriteMovies: [
            .mock,
            .mock,
            .mock,
            .mock,
            .mock,
            .mock,
            .mock,
            .mock,
            .mock,
            .mock,
            .mock
        ]
    )
}
