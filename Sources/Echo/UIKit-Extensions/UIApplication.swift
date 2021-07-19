//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-12.
//

import UIKit

extension UIApplication {
    
    static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
    }
}
