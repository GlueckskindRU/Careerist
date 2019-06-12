//
//  UIColor.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 03/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init?(hexString: String) {
        let red, green, blue: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    red = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                    green = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                    blue = CGFloat(hexNumber & 0x0000FF) / 255
                    
                    self.init(red: red, green: green, blue: blue, alpha: 1.0)
                    return
                }
            }
        }
        
        return nil
    }
}
