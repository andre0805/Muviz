//
//  DRUMRE LAB1
//  APIError.swift
//
//  Andre Flego
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
