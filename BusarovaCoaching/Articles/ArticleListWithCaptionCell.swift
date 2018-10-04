//
//  ArticleListWithCaptionCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 04/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ArticleListWithCaptionCell: UITableViewCell {
    lazy private var listCaption: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
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
    
    func configure(with caption: String, listText: String) {
        self.listCaption.text = caption
        self.listElementsLabel.text = listText
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
        contentView.addSubview(listCaption)
        contentView.addSubview(listElementsLabel)
        
        NSLayoutConstraint.activate([
            listCaption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            listCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: listCaption.trailingAnchor, constant: 16),
            
            listElementsLabel.topAnchor.constraint(equalTo: listCaption.bottomAnchor, constant: 8),
            listElementsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            contentView.trailingAnchor.constraint(equalTo: listElementsLabel.trailingAnchor, constant: 32),
            contentView.bottomAnchor.constraint(equalTo: listElementsLabel.bottomAnchor, constant: 16)
            ])
    }
}
