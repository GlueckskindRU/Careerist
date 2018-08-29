//
//  WelcomeTableCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class WelcomeTableCell: UITableViewCell {
    lazy private var menuCaption: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.medium)
        label.textAlignment = .center
        
        return label
    }()
    
    func configure(with article: AboutArticlesModel) {
        menuCaption.text = article.name
        
        addSubview(menuCaption)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            menuCaption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            menuCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: menuCaption.trailingAnchor, constant: 12),
            contentView.bottomAnchor.constraint(equalTo: menuCaption.bottomAnchor, constant: 12)
            ])
    }
}
