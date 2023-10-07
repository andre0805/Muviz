//
//  DRUMRE LAB1
//  URLSession+dataTask.swift
//
//  Andre Flego
//

import Foundation

extension URLSession {
    func dataTaskPublisher(for endpoint: Endpoint) -> DataTaskPublisher {
        dataTaskPublisher(for: endpoint.createUrlRequest())
    }
}
