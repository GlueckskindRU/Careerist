//
//  MainMenuCellLevel2.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 15/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class MainMenuCellLevel2: UITableViewCell, MainMenuCellProtocol {
    private var menuItem: MainMenuModel?
    private var delegate: MainMenuProtocol?
    private var index: Int?
    
    lazy private var menuCaption: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        label.textAlignment = .left
        
        return label
    }()
    
    func configure(with menuItem: MainMenuModel, as delegate: MainMenuProtocol, at index: Int) {
        self.menuItem = menuItem
        self.delegate = delegate
        self.index = index
        
        menuCaption.text = menuItem.name
        
        contentView.addSubview(menuCaption)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            menuCaption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            menuCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            contentView.trailingAnchor.constraint(equalTo: menuCaption.trailingAnchor, constant: 12),
            contentView.bottomAnchor.constraint(equalTo: menuCaption.bottomAnchor, constant: 4),
            menuCaption.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        
        menuCaption.sizeToFit()
    }
}
