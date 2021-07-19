//
// File.swift
//  
//
// Created by Adam Dahan on 2021-07-14.
//
// MARK: - TODO (figure out how to get UIKit out of here)

import Foundation
import UIKit

public protocol LoggingProvider {
    
    func log(
        location: String,
        data: [String],
        _ file: String,
        _ line: Int,
        _ function: String
    )
    
    func saveAndFlush()
    func rotateIfNecessary()
}
