//
//  DRUMRE LAB1
//  LocalStorage.swift
//
//  Andre Flego
//

import Foundation

enum LocalStorage {
    @Storage(key: "user", defaultValue: nil)
    static var currentUser: User?
}
