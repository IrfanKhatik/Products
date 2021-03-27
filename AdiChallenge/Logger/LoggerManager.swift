//
//  LoggerManager.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import os
import Foundation

enum LoggerCategory: String {
    case Network
    case UI
    case Default
}

class LoggerManager {
    static let shared = LoggerManager()
    let networkLogger   : Logger
    let uiLogger        : Logger
    let defaultLogger   : Logger
    
    private init() {
        let subsystem   = Bundle.main.bundleIdentifier ?? "com.adidas.challlenge.logger"
        networkLogger   = Logger(subsystem:subsystem , category: LoggerCategory.Network.rawValue)
        uiLogger        = Logger(subsystem:subsystem , category: LoggerCategory.UI.rawValue)
        defaultLogger   = Logger(subsystem:subsystem , category: LoggerCategory.Default.rawValue)
    }
}
