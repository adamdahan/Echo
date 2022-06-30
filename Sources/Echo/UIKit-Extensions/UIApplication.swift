//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-12.
//

import UIKit

extension UIApplication {
    
    static var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first
    }
}
