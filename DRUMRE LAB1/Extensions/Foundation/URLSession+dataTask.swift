//
//  twenty-minutes-ios
//  URLSession+dataTask.swift
//
//  Aras Digital Products
//

import Foundation

extension URLSession {
    func dataTaskPublisher(for endpoint: Endpoint) -> DataTaskPublisher {
        dataTaskPublisher(for: endpoint.createUrlRequest())
    }
}
