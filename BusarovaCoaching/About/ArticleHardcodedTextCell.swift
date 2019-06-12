//
//  ArticleHardcodedTextCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 07/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class ArticleHardcodedTextCell: UITableViewCell {
    lazy private var textParagraphLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    func configure(with text: String) {
        textParagraphLabel.text = text
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
        contentView.backgroundColor = .white
        contentView.addSubview(textParagraphLabel)
        
        NSLayoutConstraint.activate([
            textParagraphLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textParagraphLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textParagraphLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textParagraphLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            ])
    }
}
