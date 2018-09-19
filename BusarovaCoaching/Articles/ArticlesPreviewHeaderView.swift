//
//  ArticlesPreviewHeaderView.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 19/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ArticlesPreviewHeaderView: UITableViewHeaderFooterView {
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    func configure(with title: String?) {
        titleLabel.text = title
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 8)
            ])
    }
}
