//
//  twenty-minutes-ios
//  StartupProcess.swift
//
//  Aras Digital Products
//

import Foundation

protocol StartupProcess {
    var isEnabled: Bool { get }
    func start()
}
