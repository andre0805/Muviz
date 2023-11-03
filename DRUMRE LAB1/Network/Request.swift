//
//  DRUMRE LAB1
//  Request.swift
//
//  Andre Flego
//

import Foundation

protocol Request {
    var scheme: String { get }
    var baseURL: String { get }

    var path: String { get }
    var method: RequestMethod { get }
    var headers: [String: String] { get set }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
}

// MARK: Default implementation
extension Request {
    var scheme: String { "https" }
    var method: RequestMethod { .get }
    var queryItems: [URLQueryItem]? { nil }
    var headers: [String: String] { return [:] }
    var body: [String: Any]? { nil }
}

extension Request {
    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.path = path
        components.queryItems = queryItems

        if let url = components.url {
            return url
        }

        preconditionFailure()
    }
}
