//
//  CompetenceCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CompetenceCell: UITableViewCell {
    lazy private var cellCaption: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        
        return label
    }()
    
    func configure(with caption: String, and hasNewElements: Bool) {
        cellCaption.text = caption
        
        if hasNewElements {
            cellCaption.textColor = .red
        } else {
            cellCaption.textColor = .black
        }
        
        contentView.addSubview(cellCaption)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            cellCaption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: cellCaption.trailingAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: cellCaption.bottomAnchor, constant: 8)
            ])
        
        cellCaption.sizeToFit()
    }
}
