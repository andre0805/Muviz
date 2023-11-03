//
//  DRUMRE LAB1
//  Genre.swift
//
//  Andre Flego
//

import Foundation

extension TheMovieDB {
    struct Genre: Decodable {
        let id: Int
        let name: String
    }
}

extension TheMovieDB.Genre {
    func mapToDomainModel() -> DRUMRE_LAB1.Genre {
        .init(name: name)
    }
}

extension [TheMovieDB.Genre] {
    func mapToDomainModel() -> [DRUMRE_LAB1.Genre] {
        map { $0.mapToDomainModel() }
    }
}
