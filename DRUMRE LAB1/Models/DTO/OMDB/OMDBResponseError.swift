//
//  DRUMRE LAB1
//  OMDBResponseError.swift
//
//  Andre Flego
//

import Foundation

struct OMDBResponseError: Decodable {
    let response: String
    let error: String

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case error = "Error"
    }
}
