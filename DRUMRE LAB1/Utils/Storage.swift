//
//  DRUMRE LAB1
//  LocalStorage.swift
//
//  Andre Flego
//

import Foundation

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                return defaultValue
            }

            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                return value
            } catch {
                log.error(error)
                return defaultValue
            }
        } 

        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
