//
//  UIViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavigationMultilineTitle() {
        guard let navigationBar = self.navigationController?.navigationBar else {
            return
        }
        
        for subView in navigationBar.subviews {
            for subSubView in subView.subviews {
                guard let label = subSubView as? UILabel else {
                    break
                }
                
                if label.text == self.navigationItem.title {
                    label.numberOfLines = 0
                    label.lineBreakMode = .byWordWrapping
                    label.sizeToFit()
                    navigationBar.frame.size.height = 57 + label.frame.height
                }
            }
        }
    }
    
    @objc
    func customBackButtonTapped(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}
