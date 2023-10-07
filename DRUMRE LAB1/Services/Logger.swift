//
//  DRUMRE LAB1
//  Logger.swift
//
//  Andre Flego
//

import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

enum Logger {
    static func setup() {
        guard Application.environment == .development else { return }

        let console = ConsoleDestination()
        log.addDestination(console)

        addFileDestination()

        clearLogs()
    }

    private static func addFileDestination() {
        let file = FileDestination()

        let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        let fileURL = url?.appendingPathComponent("debug.log")

        file.logFileURL = fileURL

        log.addDestination(file)
    }
}

extension Logger {
    static func createFileURL() -> URL? {
        let fileUrl = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        guard let url = fileUrl else { return nil }
        let fileURL = url.appendingPathComponent("debug.log")
        return fileURL
    }

    static func getLogsFromFile() -> String? {
        guard let fileURL = createFileURL() else { return nil }
        return try? String(contentsOf: fileURL, encoding: .utf8)
    }

    static func clearLogs() {
        guard let fileURL = createFileURL() else { return }
        try? "".write(to: fileURL, atomically: false, encoding: .utf8)
    }
}
