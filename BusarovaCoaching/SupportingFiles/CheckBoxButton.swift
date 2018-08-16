//
//  CheckBoxButton.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 15/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CheckBoxButton: UIButton {
    
//    var onCheck: ((CheckBoxButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        self.setImage(Consts.checked, for: .selected)
        self.setImage(Consts.unchecked, for: .normal)
 print("1")
        self.addTarget(self, action: #selector(checkBoxTapped(sender:)), for: .touchUpInside)
print("2")
    }
    
    @objc
    func checkBoxTapped(sender: CheckBoxButton) {
//        onCheck?(sender)
        
    print("QQQQQQ")
        
//        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
//            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//        }) { _ in
//            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
//                sender.isSelected = !sender.isSelected
//                sender.transform = .identity
//            }, completion: nil)
//        }
    }
    
    private struct Consts {
        static let checked: UIImage = UIImage(named: "checkBoxMarked")!
        static let unchecked: UIImage = UIImage(named: "checkBoxClear")!
    }
}
