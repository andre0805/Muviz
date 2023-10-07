//
//  Hashsmith
//  Int+Extensions.swift
//
//  Andre Flego
//

import Foundation

extension Int? {
    static func -= (lhs: inout Int?, rhs: Int) {
        guard lhs != nil else { return }
        lhs = (lhs ?? 0) - rhs
    }

    static func += (lhs: inout Int?, rhs: Int) {
        guard lhs != nil else { return }
        lhs = (lhs ?? 0) + rhs
    }

    static func < (lhs: Int?, rhs: Int?) -> Bool {
        guard let lhs, let rhs else { return false }
        return lhs < rhs
    }

    static func > (lhs: Int?, rhs: Int?) -> Bool {
        guard let lhs, let rhs else { return false }
        return lhs > rhs
    }
}
