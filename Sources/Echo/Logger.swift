//
//  Coda.swift
//  Logger
//
//  Created by MoneyClip on 2021-03-03.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public final class Logger {

    /// Hide the initializer to prevent clients from instantiating this
    /// object directly.
    private init() { }

    /// Singleton dispatch
    static let main = Logger()
    
    // MARK: - Private
    
    private var currentDateString: String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: now)
    }
    
    // MARK: - Methods
    
    /// Public
    
    public func log(_ string: String) {
        do {
            try File.main.writeToEndOfEchoFile(log: string)
        } catch {
            print(error.localizedDescription)
        }
    }
}
