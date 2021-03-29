//
//  LogManager.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import os
import Foundation

// Enum for logger categories, under which logs printed
// For e.g [Network] logmessage
enum LogCategory: String {
    case Network // Category
    case UI
    case Default
}

class LogManager {
    
    static let shared = LogManager()
    
    let networkLogger   : Logger
    let uiLogger        : Logger
    let defaultLogger   : Logger
    
    private init() {
        let subsystem   = Bundle.main.bundleIdentifier ?? "com.adidas.challlenge.logger"
        
        networkLogger   = Logger(subsystem:subsystem , category: LogCategory.Network.rawValue)
        uiLogger        = Logger(subsystem:subsystem , category: LogCategory.UI.rawValue)
        defaultLogger   = Logger(subsystem:subsystem , category: LogCategory.Default.rawValue)
    }
}
