//
//  File.swift
//  
//
//  Created by Adam Dahan on 2022-12-30.
//

import Foundation
import EchoHTTP

public class EchoAtlantisDelegate: ObservableObject {
    
    @Published var packages: [EchoHTTP.TrafficPackage] = []
}

extension EchoAtlantisDelegate: AtlantisDelegate {
    
    public func atlantisDidHaveNewPackage(_ package: EchoHTTP.TrafficPackage) {
        packages.append(package)
    }
}

