//
//  DRUMRE LAB1
//  MoviesResponse.swift
//
//  Andre Flego
//

import Foundation

extension TheMovieDB {
    struct MoviesResponse: Decodable {
        let page: Int
        let results: [Movie]
        let totalPages: Int
        let totalResults: Int

        enum CodingKeys: String, CodingKey {
            case page
            case results
            case totalPages = "total_pages"
            case totalResults = "total_results"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.page = try container.decode(Int.self, forKey: .page)
            self.results = try container.decode([Movie].self, forKey: .results)
            self.totalPages = try container.decode(Int.self, forKey: .totalPages)
            self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        }
    }
}
