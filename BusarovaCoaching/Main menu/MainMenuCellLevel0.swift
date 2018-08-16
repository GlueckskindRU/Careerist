//
//  MainMenuCellLevel0.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 15/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class MainMenuCellLevel0: UITableViewCell, MainMenuCellProtocol {
    private var menuItem: MainMenuModel?
    private var delegate: MainMenuProtocol?
    private var index: Int?
    
    lazy private var menuCaption: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.medium)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(menuCaptionTappped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    func configure(with menuItem: MainMenuModel, as delegate: MainMenuProtocol, at index: Int) {
        self.menuItem = menuItem
        self.delegate = delegate
        self.index = index
        
        menuCaption.setTitle(menuItem.name, for: .normal)
        
        contentView.addSubview(menuCaption)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            menuCaption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            menuCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: menuCaption.trailingAnchor, constant: 12),
            contentView.bottomAnchor.constraint(equalTo: menuCaption.bottomAnchor, constant: 2),
            menuCaption.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    @objc
    func menuCaptionTappped(sender: Any) {
        guard
            let menuItem = menuItem,
            let index = index else {
            return
        }
        
        delegate?.menuCaptionTapped(on: menuItem, at: index)
    }
}
