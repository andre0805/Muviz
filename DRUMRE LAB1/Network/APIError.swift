//
//  DRUMRE LAB1
//  APIError.swift
//
//  Andre Flego
//

import Foundation

enum APIError: Error {
    case unknown(Error)
    case invalidURL
    case invalidData
    case invalidBody
    case invalidResponse
    case decoderFailed
}
