//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-05.
//

import Foundation
import UIKit

@available(iOS 15, *)
public func print(_ items: String..., fileId: String = #fileID, filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "") {
    guard let module = fileId.split(separator: "/").first, module != "Echo" || module != "EchoHTTP" else { return }
    var pretty = "\(Echo.main.sessionUUID.uuidString) \(Date.now) INFO \(module) \(URL(fileURLWithPath: filename).lastPathComponent) \(line) \(function)"
    let output = items.map { "\($0)" }.joined(separator: separator)
    pretty += " \(output)\n"
    Swift.print(pretty, terminator: terminator)
    Logger.main.log(pretty)
}
