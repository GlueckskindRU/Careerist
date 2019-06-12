//
//  UIAlertController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 12/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

extension UIAlertController {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let tintColor = UIColor(named: "systemTint") {
            self.view.tintColor = tintColor
        }
    }
}
