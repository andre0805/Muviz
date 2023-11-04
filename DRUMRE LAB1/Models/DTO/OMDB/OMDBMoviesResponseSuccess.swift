//
//  DRUMRE LAB1
//  OMDBMoviesResponseSuccess.swift
//
//  Andre Flego
//

import Foundation

struct OMDBMoviesResponseSuccess: Decodable {
    let search: [OMDBMovie]
    let totalResults: String
    let response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }
}
