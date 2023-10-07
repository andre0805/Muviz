//
//  DRUMRE LAB1
//  Thread+debug.swift
//
//  Andre Flego
//

import Foundation

extension Thread {
    class func printCurrent(_ id: String) {
        log.warning("\r⚡️: \(id) \(Thread.current) " + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "non")\r")
    }
}
