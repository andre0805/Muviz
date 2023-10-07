//
//  DRUMRE LAB1
//  Application.swift
//
//  Andre Flego
//

import Foundation

enum Application {
    case development
    case production
    
    static var environment: Application {
        #if PRODUCTION
        return .production
        #else
        return .development
        #endif
    }
    
    static var isRunningTests: Bool {
        return NSClassFromString("XCTestCase") != nil
    }

    static var region: String? {
        Locale.current.language.region?.identifier
    }

    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
}
