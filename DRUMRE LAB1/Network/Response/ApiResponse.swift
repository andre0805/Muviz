//
//  twenty-minutes-ios
//  ApiResponse.swift
//
//  Aras Digital Products
//

import Foundation

struct ApiResponse<T: Codable>: Codable {
    let status: Int
    let message: Int
    let payload: T
}
