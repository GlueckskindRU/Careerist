//
//  CharacteristicsCellLevel1.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 27/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CharacteristicsCellLevel1: UITableViewCell, CharacteristicsCellProtocol {
    lazy private var menuCaption: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()

    func configure(with characteristics: CharacteristicsModel) {
        menuCaption.text = characteristics.name
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
        contentView.addSubview(menuCaption)
        
        NSLayoutConstraint.activate([
            menuCaption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            menuCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            contentView.trailingAnchor.constraint(equalTo: menuCaption.trailingAnchor, constant: 12),
            contentView.bottomAnchor.constraint(equalTo: menuCaption.bottomAnchor, constant: 4),
            menuCaption.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}
