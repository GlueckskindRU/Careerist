//
//  ListElementsCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 17/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ListElementsCell: UITableViewCell {
    lazy private var bulletLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        
        return label
    }()
    
    lazy private var elementText: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    func configure(with text: String, bullet: String) {
        bulletLabel.text = bullet
        elementText.text = text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.showsReorderControl = true
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(bulletLabel)
        contentView.addSubview(elementText)
        
        NSLayoutConstraint.activate([
            bulletLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bulletLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            bulletLabel.widthAnchor.constraint(equalToConstant: 24),
            
            elementText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            elementText.leadingAnchor.constraint(equalTo: bulletLabel.trailingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: elementText.trailingAnchor, constant: 32),
            contentView.bottomAnchor.constraint(equalTo: elementText.bottomAnchor, constant: 8)
            ])
    }
}
