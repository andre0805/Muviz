//
//  twenty-minutes-ios
//  NetworkProvider.swift
//
//  Aras Digital Products
//

import Foundation
import Combine

protocol NetworkProviderProtocol {
    func request<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, Error>
}

final class NetworkProvider: NetworkProviderProtocol {
    static let shared = NetworkProvider()

    private init() {}

    func request<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, Error> {
        assert(!Thread.isMainThread, "Networking shouldn't be done on the Main thread")

        return URLSession.shared.dataTaskPublisher(for: endpoint)
            .debug(endpoint)
            .map(\.data)
            .tryMap {
                do {
                    return try JSONDecoder().decode(T.self, from: $0)
                } catch {
                    throw APIError.decoderFailed
                }
            }
            .eraseToAnyPublisher()
    }
}
