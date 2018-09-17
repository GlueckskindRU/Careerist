//
//  UITapGestureRecognizer.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 15/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

extension UITapGestureRecognizer {
    func wasTapInside(_ element: UIView) -> Bool {
        let tapLocation = self.location(in: element)
        
        return (
                tapLocation.x >= element.frame.minX
            &&  tapLocation.x <= element.frame.maxX
            &&  tapLocation.y >= element.frame.minY
            &&  tapLocation.y <= element.frame.maxY
        )
    }
}
