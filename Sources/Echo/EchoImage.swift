//
//  File.swift
//  
//
//  Created by Adam Dahan on 2023-02-11.
//

import UIKit

public func EchoImage(named name: String) -> UIImage? {
    UIImage(named: name, in: Bundle.module, compatibleWith: nil)?
        .withRenderingMode(.alwaysTemplate)
}
