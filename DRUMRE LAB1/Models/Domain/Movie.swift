//
//  DRUMRE LAB1
//  Movie.swift
//
//  Andre Flego
//

import Foundation

struct Movie: Codable, Hashable {
    let id: String
    let title: String
    let description: String
    var language: String
    let year: String
    let imageUrl: String
    var genres: [Genre]

    init(
        id: String,
        title: String,
        description: String,
        language: String,
        year: String,
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
            let id = data["id"] as? String,
            let title = data["title"] as? String,
            let description = data["description"] as? String,
            let language = data["language"] as? String,
            let year = data["year"] as? String,
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
        id: UUID().uuidString,
        title: "Titanic",
        description: "A timeless romance and disaster",
        language: "English",
        year: "1912",
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

extension [Movie] {
    static let mock: [Movie] = [
        Movie(
            id: "1",
            title: "Inception",
            description: "A thief who enters the dreams of others to steal their secrets.",
            language: "English",
            year: "2010",
            imageUrl: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcT3VT-Ynisr-nRV7R65rC8iZ4jyJKgLHU7wvROHYTnc1X7zg_4i",
            genres: [
                Genre(name: "Science Fiction")
            ]
        ),
        Movie(
            id: "2",
            title: "The Shawshank Redemption",
            description: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
            language: "English",
            year: "1994",
            imageUrl: "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTvYzmCt0-qgc4Yc1AgkRw9_ONiZ5RX1sg53__YVoLs28rfR8M-",
            genres: [
                Genre(name: "Drama")
            ]
        ),
        Movie(
            id: "3",
            title: "The Godfather",
            description: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
            language: "English",
            year: "1972",
            imageUrl: "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTPl8nOiQO7xcK7uC-LVrTT4cQTAU1eECiQf50_kWxZGtyUtZq_",
            genres: [
                Genre(name: "Crime")
            ]
        ),
    ]
}
