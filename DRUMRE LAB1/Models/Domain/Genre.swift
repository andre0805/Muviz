//
//  DRUMRE LAB1
//  Genre.swift
//
//  Andre Flego
//

import Foundation

struct Genre: Codable, Hashable {
    let name: String

    func toDictionary() -> [String: Any] {
        [
            "name": name
        ]
    }
}
