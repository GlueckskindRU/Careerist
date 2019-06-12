//
//  UIView.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorTwo.cgColor, colorOne.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
