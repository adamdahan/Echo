//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-04.
//

import Foundation

// What kind of log level is it?

public enum LogLevel: Int, CaseIterable {
    case info, warning, error, todo, fixme, debug
    
    public var description: String {
        switch self {
        case .info: return "💁‍♀️"
        case .warning: return "⚠️"
        case .error: return "🚨"
        case .todo: return "📝"
        case .fixme: return "🛠"
        case .debug: return "👾"
        }
    }
    
    public var title: String {
        switch self {
        case .info: return "info"
        case .warning: return "warning"
        case .error: return "error"
        case .todo: return "todo"
        case .fixme: return "fixme"
        case .debug: return "debug"
        }
    }
}
