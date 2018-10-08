//
//  InsideCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 12/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class InsideCell: UITableViewCell {
    lazy private var elementType: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        label.textAlignment = .left
        label.backgroundColor = UIColor.gray
        label.textColor = UIColor.white
        label.text = "Параграф текста"
        
        return label
    }()
    
    lazy private var textCaption: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    func configure(with caption: String) {
        textCaption.text = caption
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(elementType)
        contentView.addSubview(textCaption)
        
        NSLayoutConstraint.activate([
            elementType.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            elementType.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: elementType.trailingAnchor, constant: 8),
            
            textCaption.topAnchor.constraint(equalTo: elementType.bottomAnchor, constant: 8),
            textCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: textCaption.trailingAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: textCaption.bottomAnchor, constant: 8)
            ])
    }
}
