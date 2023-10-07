//
//  DRUMRE LAB1
//  User.swift
//
//  Andre Flego
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String

    init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }

    init?(from data: [String: Any]) {
        guard
            let id = data["id"] as? String,
            let name = data["name"] as? String,
            let email = data["email"] as? String
        else {
            return nil
        }
        self.id = id
        self.name = name
        self.email = email
    }
}
