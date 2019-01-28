//
//  CAShapeLayer.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/01/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    public var halfSize: CGFloat {
        return min(bounds.width, bounds.height) / 2
    }
    
    public var shapeCenterPosition: CGPoint {
        return CGPoint(x: bounds.width / 2,
                       y: bounds.height / 2
        )
    }
}
