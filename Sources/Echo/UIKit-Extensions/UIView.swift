//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-05.
//

import UIKit

public extension UIView {
    func makeScreenshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { (context) in
            self.layer.render(in: context.cgContext)
        }
    }
}
