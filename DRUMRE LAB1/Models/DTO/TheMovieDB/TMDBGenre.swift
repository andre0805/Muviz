//
//  DRUMRE LAB1
//  TMDBGenre.swift
//
//  Andre Flego
//

import Foundation

struct TMDBGenre: Decodable {
    let id: Int
    let name: String
}

extension TMDBGenre {
    func mapToDomainModel() -> Genre {
        .init(name: name)
    }
}

extension [TMDBGenre] {
    func mapToDomainModel() -> [Genre] {
        map { $0.mapToDomainModel() }
    }
}
