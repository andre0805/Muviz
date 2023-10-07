//
//  twenty-minutes-ios
//  APIError.swift
//
//  Aras Digital Products
//

import Foundation

enum APIError: Error {
    case unknown(Error)
    case decoderFailed

    var message: String {
        switch self {
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        case .decoderFailed:
            return "Error: Can't create model from response"
        }
    }
}
