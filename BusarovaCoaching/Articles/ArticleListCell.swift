//
//  ArticleListCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 19/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ArticleListCell: UITableViewCell {
    lazy private var listElementsLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    func configure(with text: String) {
        listElementsLabel.text = text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(listElementsLabel)
        
        NSLayoutConstraint.activate([
            listElementsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            listElementsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            contentView.trailingAnchor.constraint(equalTo: listElementsLabel.trailingAnchor, constant: 32),
            contentView.bottomAnchor.constraint(equalTo: listElementsLabel.bottomAnchor, constant: 16)
            ])
    }
}
