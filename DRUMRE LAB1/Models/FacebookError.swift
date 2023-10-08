//
//  DRUMRE LAB1
//  FacebookError.swift
//
//  Andre Flego
//

import Foundation

enum FacebookError: Error {
    case unknown(Error)
    case cancelledLogin
    case invalidUserData

    var message: String {
        switch self {
        case .unknown(let error):
            return error.localizedDescription
        case .cancelledLogin:
            return "User cancelled Facebook login"
        case .invalidUserData:
            return "Failed to create user from Facebook data"
        }
    }
}

extension FacebookError: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.cancelledLogin, .cancelledLogin), (.invalidUserData, .invalidUserData):
            return true
        case (.unknown(let lhsError), .unknown(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
