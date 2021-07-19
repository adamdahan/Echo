//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-04.
//

import UIKit

extension UINavigationController {
    public override func topMostViewController() -> UIViewController {
        return self.visibleViewController!.topMostViewController()
    }
}
