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
    private(set) var userData: UserData?

    init(id: String, name: String, email: String, userData: UserData? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.userData = userData
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
        self.userData = nil
    }

    func toDictionary() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "email": email,
            "userData": userData?.toDictionary() ?? [:]
        ]
    }
}
