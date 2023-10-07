//
//  DRUMRE LAB1
//  ApiResponse.swift
//
//  Andre Flego
//

import Foundation

struct ApiResponse<T: Codable>: Codable {
    let status: Int
    let message: Int
    let payload: T
}
