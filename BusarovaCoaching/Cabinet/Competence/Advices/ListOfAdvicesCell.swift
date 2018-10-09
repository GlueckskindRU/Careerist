//
//  ListOfAdvicesCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 08/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ListOfAdvicesCell: UITableViewCell {
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    func configure(with advice: Article, as sequance: Int) {
        titleLabel.text = advice.title.isEmpty ? "Совет дня № \(sequance)" : advice.title
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
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
            ])
    }
}
