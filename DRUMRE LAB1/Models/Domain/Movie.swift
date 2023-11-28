//
//  DRUMRE LAB1
//  Movie.swift
//
//  Andre Flego
//

import Foundation

struct Movie: Codable, Hashable {
    let id: String;
    let tmdbId: Int;
    let imdbId: String;
    let title: String;
    let description: String;
    let releaseDate: Date;
    let genres: [Genre];
    let duration: Int?;
    let director: String;
    let actors: [String];
    let languages: [String];
    let countries: [String];
    let posterUrl: String;
    let rating: Float?;

    init(
        id: String,
        tmdbId: Int,
        imdbId: String,
        title: String,
        description: String,
        releaseDate: Date,
        genres: [Genre],
        duration: Int?,
        director: String,
        actors: [String],
        languages: [String],
        countries: [String],
        posterUrl: String,
        rating: Float?
    ) {
        self.id = id
        self.tmdbId = tmdbId
        self.imdbId = imdbId
        self.title = title
        self.description = description
        self.releaseDate = releaseDate
        self.genres = genres
        self.duration = duration
        self.director = director
        self.actors = actors
        self.languages = languages
        self.countries = countries
        self.posterUrl = posterUrl
        self.rating = rating
    }

    func getYear() -> String {
        Calendar.current.component(.year, from: releaseDate).description
    }
}

// MARK: Encoder/Decoder
extension Movie {
    enum CodingKeys: CodingKey {
        case id
        case tmdbId
        case imdbId
        case title
        case description
        case releaseDate
        case genres
        case duration
        case director
        case actors
        case languages
        case countries
        case posterUrl
        case rating
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.tmdbId = try container.decode(Int.self, forKey: .tmdbId)
        self.imdbId = try container.decode(String.self, forKey: .imdbId)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)

        let dateString = try container.decode(String.self, forKey: .releaseDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        self.releaseDate = dateFormatter.date(from: dateString) ?? .now

        self.genres = try container.decode([Genre].self, forKey: .genres)
        self.duration = try container.decode(Int?.self, forKey: .duration)
        self.director = try container.decode(String.self, forKey: .director)
        self.actors = try container.decode([String].self, forKey: .actors)
        self.languages = try container.decode([String].self, forKey: .languages)
        self.countries = try container.decode([String].self, forKey: .countries)
        self.posterUrl = try container.decode(String.self, forKey: .posterUrl)
        self.rating = try container.decode(Float?.self, forKey: .rating)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.tmdbId, forKey: .tmdbId)
        try container.encode(self.imdbId, forKey: .imdbId)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let dateString = dateFormatter.string(from: self.releaseDate)
        try container.encode(dateString, forKey: .releaseDate)

        try container.encode(self.genres, forKey: .genres)
        try container.encode(self.duration, forKey: .duration)
        try container.encode(self.director, forKey: .director)
        try container.encode(self.actors, forKey: .actors)
        try container.encode(self.languages, forKey: .languages)
        try container.encode(self.countries, forKey: .countries)
        try container.encode(self.posterUrl, forKey: .posterUrl)
        try container.encode(self.rating, forKey: .rating)
    }
}

extension Movie: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension Movie {
    static let mock = Movie(
        id: UUID().uuidString,
        tmdbId: 1,
        imdbId: UUID().uuidString,
        title: "Titanic",
        description: "A timeless romance and disaster",
        releaseDate: .now,
        genres: [
            .init(id: 1, name: "Drama"),
            .init(id: 2, name: "Documentary")
        ],
        duration: 120,
        director: "John Doe",
        actors: [
            "Pero Peric",
            "Mate Matic",
            "Iva Ivic"
        ],
        languages: ["english"],
        countries: ["USA"],
        posterUrl: "https://m.media-amazon.com/images/I/811lT7khIrL._SY679_.jpg",
        rating: 8.4
    )
}

extension [Movie] {
    static let mock: [Movie] = [
        .mock,
        .mock,
        .mock
    ]
}
