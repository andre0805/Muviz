//
//  DRUMRE LAB1
//  GenresResponse.swift
//
//  Andre Flego
//

import Foundation

extension TheMovieDB {
    struct GenresResponse: Decodable {
        let genres: [Genre]
    }
}
