//
//  TabBarController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 05/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    fileprivate lazy var defaultTabBarHeight: CGFloat = {
        tabBar.frame.size.height
    }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let newTabBarHeight = defaultTabBarHeight + 16.0
        
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        
        tabBar.frame = newFrame
    }
}
