//
//  DRUMRE LAB1
//  Movie.swift
//
//  Andre Flego
//

import Foundation

struct Movie: Codable, Hashable {
    let id: Int
    let title: String
    let description: String
    var language: String
    let year: Int
    let imageUrl: String
    var genres: [Genre]

    init(
        id: Int,
        title: String,
        description: String,
        language: String,
        year: Int,
        imageUrl: String,
        genres: [Genre]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.language = language
        self.year = year
        self.imageUrl = imageUrl
        self.genres = genres
    }

    init?(from data: [String: Any]) {
        guard
            let id = data["id"] as? Int,
            let title = data["title"] as? String,
            let description = data["description"] as? String,
            let language = data["language"] as? String,
            let year = data["year"] as? Int,
            let imageUrl = data["imageUrl"] as? String,
            let genresData = data["genres"] as? [[String: Any]]
        else {
            return nil
        }

        self.id = id
        self.title = title
        self.description = description
        self.language = language
        self.year = year
        self.imageUrl = imageUrl
        self.genres = genresData.compactMap { Genre(from: $0) }
    }

    func toDictionary() -> [String: Any] {
        [
            "id": id,
            "title": title,
            "description": description,
            "language": language,
            "year": year,
            "imageUrl": imageUrl,
            "genres": genres.map { $0.toDictionary() }
        ]
    }

    static let mock = Movie(
        id: 1,
        title: "Titanic",
        description: "A timeless romance and disaster",
        language: "English",
        year: 1912,
        imageUrl: "https://m.media-amazon.com/images/I/811lT7khIrL._SY679_.jpg",
        genres: [
            .init(name: "Drama"),
            .init(name: "Documentary")
        ]
    )
}

extension Movie: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.language == rhs.language &&
        lhs.year == rhs.year &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.genres == rhs.genres
    }
}
