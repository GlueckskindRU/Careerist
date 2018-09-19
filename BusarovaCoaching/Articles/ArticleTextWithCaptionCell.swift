//
//  ArticleTextWithCaptionCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 19/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ArticleTextWithCaptionCell: UITableViewCell {
    lazy private var paragraphCaptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy private var paragraphTextLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    func configure(with caption: String, text: String) {
        paragraphCaptionLabel.text = caption
        paragraphTextLabel.text = text
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
        contentView.addSubview(paragraphCaptionLabel)
        contentView.addSubview(paragraphTextLabel)
        
        NSLayoutConstraint.activate([
            paragraphCaptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            paragraphCaptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: paragraphCaptionLabel.trailingAnchor, constant: 16),
            
            paragraphTextLabel.topAnchor.constraint(equalTo: paragraphCaptionLabel.bottomAnchor, constant: 8),
            paragraphTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: paragraphTextLabel.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: paragraphTextLabel.bottomAnchor, constant: 16)
            ])
    }
}
