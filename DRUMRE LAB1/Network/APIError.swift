//
//  DRUMRE LAB1
//  APIError.swift
//
//  Andre Flego
//

import Foundation

enum APIError: LocalizedError {
    case unknown(Error)
    case invalidURL
    case invalidData
    case invalidBody
    case invalidResponse
    case decoderFailed

    case userNotFound
    case userAlreadyExists

    var errorDescription: String {
        switch self {
        case .unknown(let error):
            error.localizedDescription
        case .invalidURL:
            "Invalid URL"
        case .invalidData:
            "Invalid data"
        case .invalidBody:
            "Invalid body"
        case .invalidResponse:
            "Invalid response"
        case .decoderFailed:
            "Couldn't decode response data"
        case .userNotFound:
            "User not found"
        case .userAlreadyExists:
            "User already exists"
        }
    }
}
