//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-05.
//

import Foundation
import UIKit

public func print(_ items: String..., fileId: String = #fileID, filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n") {
//    #if DEBUG
//
//        /// This could be a huge problem. What if the module the user is already using is called Echo?
//        guard let module = fileId.split(separator: "/").first, module != "Echo" else { return }
//        Swift.print("module: \(module)")
//        let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\n\t-> "
//        let output = items.map { "\($0)" }.joined(separator: separator)
//        Swift.print(pretty+output, terminator: terminator)
//        Logger.main.log(pretty+output)
//    #else
//        Swift.print("RELEASE MODE")
//    #endif
    /// This could be a huge problem. What if the module the user is already using is called Echo?
    guard let module = fileId.split(separator: "/").first, module != "Echo" else { return }
    Swift.print("module: \(module)")
    let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\n\t-> "
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(pretty+output, terminator: terminator)
    Logger.main.log(pretty+output)
}

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//    #if DEBUG
//        let output = items.map { "\($0)" }.joined(separator: separator)
//        //Swift.print(output, terminator: terminator)
//        Logger.main.log(output)
//    #else
//        Swift.print("RELEASE MODE")
//    #endif
    let output = items.map { "\($0)" }.joined(separator: separator)
    //Swift.print(output, terminator: terminator)
    Logger.main.log(output)
}

