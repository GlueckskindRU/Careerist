//
//  TableFooterView.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 13/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class TableFooterView {
    static let shared = TableFooterView()
    
    private init() { }
    
    func create(with text: String, in view: UIView, empty: Bool) -> UIView {
        if empty {
            let height = view.frame.size.height / 2
            let width = view.frame.size.width - 35
            let frame = CGRect(origin: CGPoint(x: 10,
                                               y: height / 3),
                               size: CGSize(width: width,
                                            height: height)
                                )
            
            let view = UIView(frame: frame)
            
            let label = UILabel(frame: frame)
            label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.text = text
            label.sizeToFit()
            
            view.addSubview(label)
            
            return view
        } else {
            return UIView()
        }
    }
}
