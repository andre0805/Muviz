//
//  DRUMRE LAB1
//  OMDBMovie.swift
//
//  Andre Flego
//

import Foundation

struct OMDBMovie: Decodable {
    let id: String
    let title: String
    let year: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
    }
}

struct OMDBMovieDetails: Decodable {
    let id: String
    let title: String
    let plot: String
    let language: String
    let year: String
    let poster: String
    let genre: String

    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case plot = "Plot"
        case language = "Language"
        case year = "Year"
        case poster = "Poster"
        case genre = "Genre"
    }
}

extension OMDBMovieDetails {
    func mapToDomainModel() -> Movie {
        .init(
            id: id,
            title: title,
            description: plot,
            language: language,
            year: year,
            imageUrl: poster,
            genres: genre.split(separator: ", ").map { Genre(name: String($0)) }
        )
    }
}

extension [OMDBMovieDetails] {
    func mapToDomainModel() -> [Movie] {
        map { $0.mapToDomainModel() }
    }
}
