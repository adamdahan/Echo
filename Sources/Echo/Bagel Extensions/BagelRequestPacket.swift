//
//  BagelRequestPacket.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import Foundation
import EchoHTTP

extension BagelRequestPacket {
    
    var statusColor: UIColor {
        guard let status = Int(requestInfo.statusCode ?? "0") else { return .systemRed }
        switch status {
        case 200...299:
            return .systemGreen
        case 300...399:
            return .systemYellow
        case 400...499:
            return .systemOrange
        case 500...599:
            return .systemRed
        default:
            return .systemRed
        }
    }
}

extension BagelRequestPacket: Identifiable {
    
}
