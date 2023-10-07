//
//  twenty-minutes-ios
//  Thread+debug.swift
//
//  Aras Digital Products
//

import Foundation

extension Thread {
    class func printCurrent(_ id: String) {
        log.warning("\r⚡️: \(id) \(Thread.current) " + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "non")\r")
    }
}
