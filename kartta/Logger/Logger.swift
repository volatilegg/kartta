//
//  Logger.swift
//  kartta
//
//  Created by Duc Do on 17.9.2024.
//

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")

    /// All others related to services and manager
    static let services = Logger(subsystem: subsystem, category: "services")

    /// All others related to services and manager
    static let network = Logger(subsystem: subsystem, category: "network")

    /// All others logs
    static let others = Logger(subsystem: subsystem, category: "others")

}
