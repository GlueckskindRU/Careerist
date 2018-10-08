//
//  CharacteristicsArticlesCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 12/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CharacteristicsArticlesCell: UITableViewCell {
    lazy private var articleTypeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        label.textAlignment = .left
        label.backgroundColor = UIColor.gray
        label.textColor = UIColor.white
        
        return label
    }()
    
    lazy private var articleTitleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    func configure(with article: Article) {
        switch article.type {
        case .article:
            articleTypeLabel.text = "Статья"
            articleTitleLabel.text = "Статья без названия!"
        case .advice:
            articleTypeLabel.text = "Совет дня"
            articleTitleLabel.text = "Совет дня без заголовка"
        case .testQuestion:
            articleTypeLabel.text = "Тестовый вопрос"
            articleTitleLabel.text = "Тестовый вопрос без заголовка"
        }
        
        articleTypeLabel.sizeToFit()
        
        if article.title != "" {
            articleTitleLabel.text = article.title
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
        contentView.addSubview(articleTypeLabel)
        contentView.addSubview(articleTitleLabel)
        
        NSLayoutConstraint.activate([
            articleTypeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            articleTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            articleTitleLabel.topAnchor.constraint(equalTo: articleTypeLabel.bottomAnchor, constant: 8),
            articleTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: articleTitleLabel.trailingAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: 8)
            ])
    }
}
