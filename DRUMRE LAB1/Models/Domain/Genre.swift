//
//  DRUMRE LAB1
//  Genre.swift
//
//  Andre Flego
//

import Foundation

struct Genre: Codable, Hashable {
    let id: Int
    let name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
