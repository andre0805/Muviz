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

    static let mock: Movie = Movie(
        id: 1,
        title: "Titanic",
        description: "A timeless romance and disaster film directed by James Cameron. It tells the story of Jack and Rose, two passengers from different social classes who fall in love during the ill-fated maiden voyage of the RMS Titanic. Their love is tested as the ship collides with an iceberg, leading to a tragic and heroic struggle for survival. The film combines a captivating love story with the real historical events of the Titanic's sinking, creating an emotional and visually stunning cinematic experience.",
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
