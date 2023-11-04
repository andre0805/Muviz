//
//  DRUMRE LAB1
//  OMDBMoviesResponse.swift
//
//  Andre Flego
//

import Foundation

enum OMDBMoviesResponse<T>: Decodable where T: Decodable {
    case success(T)
    case error(OMDBResponseError)

    public init(from data: Data) throws {
        if let success = try? JSONDecoder().decode(T.self, from: data) {
            self = .success(success)
            return
        }

        if let error = try? JSONDecoder().decode(OMDBResponseError.self, from: data) {
            self = .error(error)
            return
        }

        throw APIError.invalidResponse  
    }
}
