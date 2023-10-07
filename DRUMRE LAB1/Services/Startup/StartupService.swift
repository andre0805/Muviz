//
//  twenty-minutes-ios
//  StartupService.swift
//
//  Aras Digital Products
//

import Foundation

final class StartupService {
    private var processes: [StartupProcess] = []

    func start(process: StartupProcess) {
        guard process.isEnabled else { return }
        process.start()
    }
    
    func start(processes: [StartupProcess]) {
        self.processes = processes
        processes.forEach(start)
    }
}
