//
//  DRUMRE LAB1
//  TMDBMovie.swift
//
//  Andre Flego
//

import Foundation

struct TMDBMovie: Codable, Hashable {
    let id: Int
    let title: String
    let overview: String
    var originalLanguage: String
    let releaseDate: String
    let genreIds: [Int]
    let posterPath: String
}

extension TMDBMovie {
    func mapToDomainModel(withGenres genres: [TMDBGenre] = []) -> Movie {
        .init(
            id: id,
            title: title,
            description: overview,
            language: getLanguage(for: originalLanguage),
            year: Int(releaseDate.prefix(4)) ?? 0,
            imageUrl: Constants.TheMovieDB.imageBaseURL + posterPath,
            genres: getGenres(from: genres)
        )
    }

    private func getLanguage(for isoCode: String) -> String {
        Constants.TheMovieDB.languageNames.getValue(for: isoCode) ?? isoCode
    }

    private func getGenres(from genres: [TMDBGenre]) -> [Genre] {
        genreIds
            .compactMap { genreId in
                genres.first(where: { $0.id == genreId })?.name
            }
            .map { Genre(name: $0) }
    }
}

extension [TMDBMovie] {
    func mapToDomainModel(withGenres genres: [TMDBGenre] = []) -> [Movie] {
        map { $0.mapToDomainModel(withGenres: genres) }
    }
}

// MARK: Movie + Decoder
extension TMDBMovie {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case originalLanguage = "original_language"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case posterPath = "poster_path"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.genreIds = try container.decode([Int].self, forKey: .genreIds)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
    }
}

// MARK: Movie + Encoder
//extension Movie {
//    enum EncodingKeys: String, CodingKey {
//        case id
//        case title
//        case description
//        case language
//        case year
//        case genre
//        case imageUrl
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: EncodingKeys.self)
//        try container.encode(self.title, forKey: .title)
//        try container.encode(self.description, forKey: .description)
//        try container.encode(self.language, forKey: .language)
//        try container.encode(self.year, forKey: .year)
//        try container.encode(self.genre, forKey: .genre)
//        try container.encode(self.imageUrl, forKey: .imageUrl)
//    }
//}
