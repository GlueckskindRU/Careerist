//
//  CabinetCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CabinetCell: UITableViewCell {
    lazy private var menuCaption: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        
        return label
    }()
    
    func configure(with menuCaption: String) {
        self.menuCaption.text = menuCaption
        
        contentView.addSubview(self.menuCaption)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            menuCaption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            menuCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: menuCaption.trailingAnchor, constant: 4),
            contentView.bottomAnchor.constraint(equalTo: menuCaption.bottomAnchor, constant: 4)
            ])
        
        menuCaption.sizeToFit()
    }
}
