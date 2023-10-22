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
    let imageUrl: String?
    var userData: UserData?

    init(id: String, name: String, email: String, imageUrl: String? = nil, userData: UserData? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.imageUrl = imageUrl
        self.userData = userData
    }

    init?(from data: [String: Any])  {
        guard
            let id = data["id"] as? String,
            let name = data["name"] as? String,
            let email = data["email"] as? String,
            let imageUrl = data["imageUrl"] as? String
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.email = email
        self.imageUrl = imageUrl
        self.userData = nil
    }

    func toDictionary() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "email": email,
            "imageUrl": imageUrl ?? "",
            "userData": userData?.toDictionary() ?? [:]
        ]
    }
}

extension User: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.email == rhs.email &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.userData == rhs.userData
    }
}
