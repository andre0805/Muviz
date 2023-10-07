//
//  DRUMRE LAB1
//  Dictionary+Extensions.swift
//
//  Andre Flego
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
