//
//  ArticleImageWithCaptionCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 19/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ArticleImageWithCaptionCell: UITableViewCell {
    lazy private var articleImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy private var paragraphCaptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    func configure(with image: UIImage, caption: String) {
        articleImageView.image = image
        paragraphCaptionLabel.text = caption
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
        contentView.addSubview(articleImageView)
        
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 16),
            
            paragraphCaptionLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 8),
            paragraphCaptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: paragraphCaptionLabel.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: paragraphCaptionLabel.bottomAnchor, constant: 16)
            ])
    }
}
