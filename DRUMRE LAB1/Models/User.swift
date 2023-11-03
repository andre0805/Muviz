//
//  DRUMRE LAB1
//  User.swift
//
//  Andre Flego
//

import Foundation

struct User: Codable {
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
        self.favoriteMovies = data["favoriteMovies"] as? [Movie] ?? []
    }

    mutating func addMovieToFavorites(_ movie: Movie) {
        favoriteMovies.append(movie)
    }

    mutating func removeMovieFromFavorites(_ movie: Movie) {
        favoriteMovies.removeAll(where: { $0 == movie })
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

extension User: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.email == rhs.email &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.favoriteMovies == rhs.favoriteMovies
    }
}
