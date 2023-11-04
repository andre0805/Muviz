//
//  DRUMRE LAB1
//  TMDBGenresResponse.swift
//
//  Andre Flego
//

import Foundation

struct TMDBGenresResponse: Decodable {
    let genres: [TMDBGenre]
}
