//
//  twenty-minutes-ios
//  Publisher+Utility.swift
//
//  Aras Digital Products
//

import Foundation
import Combine

extension Publisher {
    /// Maps each sequence element to given value.
    ///
    /// - Parameter value: Value to map
    /// - Returns: Sequence where all elements are given value.
    func mapTo<T>(_ value: T) -> Publishers.Map<Self, T> {
        map { _ in value }
    }


    /// Maps each sequence element to Void type.
    ///
    /// - Returns: Sequence where all elements are of Void type.
    func mapToVoid() -> Publishers.Map<Self, Void> {
        mapTo(())
    }
}

extension Publisher where Output == URLSession.DataTaskPublisher.Output, Failure == URLError {
    func debug(_ endpoint: Endpoint) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { res in
            guard let json = try? JSONSerialization.jsonObject(with: res.data, options: .mutableContainers),
                // swiftlint:disable:next line_length
                let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else { return }
            let pretty = String(decoding: jsonData, as: UTF8.self)
            log.info("\nENDPOINT: \(endpoint.path)\nRESPONSE: \(pretty)\n")
        })
    }
}
