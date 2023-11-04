//
//  DRUMRE LAB1
//  Genre.swift
//
//  Andre Flego
//

import Foundation

struct Genre: Codable, Hashable {
    let name: String

    init(name: String) {
        self.name = name
    }

    init?(from data: [String: Any]) {
        guard
            let name = data["name"] as? String
        else {
            return nil
        }

        self.name = name
    }

    func toDictionary() -> [String: Any] {
        [
            "name": name
        ]
    }
}
