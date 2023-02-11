//
//  File.swift
//  
//
//  Created by Adam Dahan on 2023-02-11.
//

import UIKit

final class ShadowButton: UIButton {

    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 30).cgPath
            shadowLayer.fillColor = UIColor.black.cgColor

            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.0, height: -1.0)
            shadowLayer.shadowOpacity = 1
            shadowLayer.shadowRadius = 10

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }

}
