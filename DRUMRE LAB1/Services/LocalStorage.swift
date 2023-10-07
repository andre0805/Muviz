//
//  twenty-minutes-ios
//  LocalStorage.swift
//
//  Aras Digital Products
//

import Foundation

enum LocalStorage {
    @Storage(key: "ALERTED_VERSION", defaultValue: "0.1")
    static var alertedVersion: String?
}
