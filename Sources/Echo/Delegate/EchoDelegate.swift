//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-08.
//

import Foundation
import EchoHTTP

public protocol EchoDelegate {
        
    func post(log: Log, attachments: [URL])
}
