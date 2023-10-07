//
//  DRUMRE LAB1
//  Endpoint.swift
//
//  Andre Flego
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var baseUrl: String { get }

    var path: String { get }
    var method: RequestMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }

    func createUrlRequest() -> URLRequest
}

// MARK: Default implementation
extension Endpoint {
    var scheme: String { "https" }
    #warning("Don't use mock when we move away from Postman mock server")
    var baseUrl: String { Constants.API.mockServerBaseUrl }
    var path: String {
        fatalError("Missing path implementation")
    }
    var method: RequestMethod { .get }
    var queryItems: [URLQueryItem]? { nil }
    var headers: [String: String] { return [:] }
    var body: [String: Any]? { nil }

    func createUrlRequest() -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        if let body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                assertionFailure("invalidBody")
            }
        }

        if self is Authorizable {
            urlRequest.setValue("TODO", forHTTPHeaderField: "authToken")
        } else {
            log.info("Not Authorizable")
        }

        return urlRequest
    }
}

private extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseUrl
        components.path = path
        components.queryItems = queryItems

        if let url = components.url {
            return url
        }

        preconditionFailure()
    }
}
