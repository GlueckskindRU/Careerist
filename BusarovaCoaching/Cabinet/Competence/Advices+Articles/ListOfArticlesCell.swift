//
//  ListOfArticlesCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/12/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ListOfArticlesCell: UITableViewCell {
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    func configure(with asset: ReceivedAsset, as sequance: Int) {
        titleLabel.text = asset.asset.title.isEmpty ? "Статья № \(sequance)" : asset.asset.title
        if !asset.wasRead {
            contentView.backgroundColor = UIColor.lightGray
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        } else {
            contentView.backgroundColor = UIColor.white
        }
        
        if asset.hasQuestions {
            if asset.wasRead && asset.passed {
                titleLabel.textColor = .green
            } else {
                titleLabel.textColor = .red
            }
        } else {
            if !asset.wasRead  {
                titleLabel.textColor = .red
            } else {
                titleLabel.textColor = .black
            }
        }
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
