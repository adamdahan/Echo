//
//  BagelRequestPacket.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import UIKit
import EchoHTTP

extension EchoHTTP.TrafficPackage {
    
    var statusColor: UIColor {
        guard let code = response?.statusCode else { return .systemRed }
        switch code {
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
