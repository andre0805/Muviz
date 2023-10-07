//
//  twenty-minutes-ios
//  DispatchQueueFactory.swift
//
//  Aras Digital Products
//

import Foundation

enum DispatchQueueFactory {
    private static let defaultLabel = "co.arasdigital.twenty-minutes.default"
    private static let networkingLabel = "co.arasdigital.twenty-minutes.networking"

    static var main: DispatchQueue {
        return DispatchQueue.main
    }

    /// DispatchQueue used for networking requests
    static var networking: DispatchQueue {
        return DispatchQueue(label: networkingLabel, qos: .utility)
    }

    /// The .userInteractive QoS is recommended for tasks that the user directly interacts with.
    /// UI-updating calculations, animations or anything needed to keep the UI responsive and fast.
    /// If the work doesn’t happen quickly, things may appear to freeze.
    /// Tasks submitted to this queue should complete virtually instantaneously.
    static var userInteractive: DispatchQueue {
        return DispatchQueue(label: defaultLabel, qos: .userInteractive)
    }

    /// The .userInitiated queue should be used when the user kicks off a task from the UI that needs to happen immediately,
    /// but can be done asynchronously.
    /// For example, you may need to open a document or read from a local database.
    /// If the user clicked a button, this is probably the queue you want.
    /// Tasks performed in this queue should take a few seconds or less to complete.
    static var userInitiated: DispatchQueue {
        return DispatchQueue(label: defaultLabel, qos: .userInitiated)
    }

    /// You’ll want to use the .utility dispatch queue for tasks that would typically include a progress
    /// indicator such as long-running computations, I/O, networking or continuous data feeds.
    /// The system tries to balance responsiveness and performance with energy efficiency.
    /// Tasks can take a few seconds to a few minutes in this queue.
    static var utility: DispatchQueue {
        return DispatchQueue(label: defaultLabel, qos: .utility)
    }

    /// For tasks that the user is not directly aware of you should use the .background queue.
    /// They don’t require user interaction and aren’t time sensitive. Prefetching, database maintenance, synchronizing remote
    /// servers and performing backups are all great examples.
    /// The OS will focus on energy efficiency instead of speed.
    /// You’ll want to use this queue for work that will take significant time, on the order of minutes or more.
    static var background: DispatchQueue {
        return DispatchQueue(label: defaultLabel, qos: .utility)
    }
}
