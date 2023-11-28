//
//  DRUMRE LAB1
//  RequestBuilder.swift
//
//  Andre Flego
//

import Foundation

class RequestBuilder {
    private var scheme: String = "https"
    private var baseURL: String
    private var port: Int?
    private var path: String
    private var method: RequestMethod = .get
    private var headers: [String: String] = [:]
    private var queryItems: [URLQueryItem]?
    private var body: [String: Any]?

    init(baseURL: String, port: Int? = nil, path: String) {
        self.baseURL = baseURL
        self.port = port
        self.path = path
    }

    func setScheme(_ scheme: String) -> RequestBuilder {
        self.scheme = scheme
        return self
    }

    func setMethod(_ method: RequestMethod) -> RequestBuilder {
        self.method = method
        return self
    }

    func setHeaders(_ headers: [String: String]) -> RequestBuilder {
        headers.forEach { key, value in
            self.headers.updateValue(value, forKey: key)
        }
        return self
    }

    func addHeader(_ value: String, forKey key: String) -> RequestBuilder {
        self.headers.updateValue(value, forKey: key)
        return self
    }

    func setQueryItems(_ queryItems: [URLQueryItem]?) -> RequestBuilder {
        self.queryItems = queryItems
        return self
    }

    func addQueryItem(_ value: String?, forKey key: String) -> RequestBuilder {
        if queryItems != nil {
            queryItems?.append(URLQueryItem(name: key, value: value))
        } else {
            queryItems = [URLQueryItem(name: key, value: value)]
        }
        return self
    }

    func setBody(_ body: [String: Any]?) -> RequestBuilder {
        self.body = body
        return self
    }

    func addBody(_ value: Any, forKey key: String) -> RequestBuilder {
        if body != nil {
            body?.updateValue(value, forKey: key)
        } else {
            body = [key: value]
        }
        return self
    }

    func build() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.port = port
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers

        if let body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw APIError.invalidBody
            }
        }

        return urlRequest
    }
}
