//
//  HeaderViewWithInfoText.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 05/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class HeaderViewWithInfoText: UITableViewHeaderFooterView {
    lazy private var infoLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor(named: "infoTextColor") ?? .gray
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    func configure(infoText: String) {
        infoLabel.text = infoText
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
        infoLabel.preferredMaxLayoutWidth = infoLabel.bounds.width
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.addSubview(infoLabel)
        
        let leadingMargin: CGFloat = 16
        let bottomMargin: CGFloat = -8
        let priority: Float = 999

        let infoTopConstraint = infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        infoTopConstraint.priority = UILayoutPriority(rawValue: priority)
        
        let infoLeadingConstraint = infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingMargin)
        infoLeadingConstraint.priority = UILayoutPriority(rawValue: priority)

        let infoTrailingConstraint = infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50)
        infoTrailingConstraint.priority = UILayoutPriority(rawValue: priority)

        let infoBottomConstraint = infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomMargin * 2)
        infoBottomConstraint.priority = UILayoutPriority(rawValue: priority)
        
        NSLayoutConstraint.activate([
            infoTopConstraint,
            infoLeadingConstraint,
            infoTrailingConstraint,
            infoBottomConstraint,
            ])
    }
}
