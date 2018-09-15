//
//  ActivityIndicator.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ActivityIndicator: UIView {
    lazy private var activityIndicator: UIActivityIndicatorView = {
        $0.activityIndicatorViewStyle = .whiteLarge
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIActivityIndicatorView())
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        
        self.stop()
        
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        self.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    public func stop() {
        self.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
