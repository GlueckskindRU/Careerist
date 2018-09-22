//
//  CharacteristicsArticlesCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 12/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CharacteristicsArticlesCell: UITableViewCell {
    lazy private var articleTitle: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    func configure(with article: Article) {
        if article.title == "" {
            articleTitle.text = "Статья без названия!"
        } else {
            articleTitle.text = article.title
        }
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
        contentView.addSubview(articleTitle)
        
        NSLayoutConstraint.activate([
            articleTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            articleTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: articleTitle.trailingAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: articleTitle.bottomAnchor, constant: 8)
            ])
    }
}
