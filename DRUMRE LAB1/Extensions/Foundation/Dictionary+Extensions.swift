//
//  twenty-minutes-ios
//  Dictionary+Extensions.swift
//
//  Aras Digital Products
//

import Foundation

extension Dictionary {
    func getValue(for key: Key) -> Value? {
        self[key]
    }
    
    mutating func setValue(_ value: Value, for key: Key) {
        updateValue(value, forKey: key)
    }
}
