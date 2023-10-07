//
//  twenty-minutes-ios
//  LoggerStartupProcess.swift
//
//  Aras Digital Products
//

import Foundation

final class LoggerStartupProcess: StartupProcess {
    let isEnabled = true

    func start() {
        Logger.setup()
    }
}
