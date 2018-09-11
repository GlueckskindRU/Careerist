//
//  CharacteristicsCellLevel1.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 27/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CharacteristicsCellLevel1: UITableViewCell, CharacteristicsCellProtocol {
    private var characteristic: CharacteristicsModel?
    private var delegate: CharacteristicsProtocol?
    private var index: Int?
    
    lazy private var menuCaption: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        button.titleLabel?.numberOfLines = 0
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(menuCaptionTappped(sender:)), for: .touchUpInside)
        
        return button
    }()

    func configure(with characteristics: CharacteristicsModel, as delegate: CharacteristicsProtocol, at index: Int) {
        self.characteristic = characteristics
        self.delegate = delegate
        self.index = index
        
        menuCaption.setTitle(characteristics.name, for: .normal)
        
//        contentView.addSubview(menuCaption)
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        NSLayoutConstraint.activate([
//            menuCaption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
//            menuCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
//            contentView.trailingAnchor.constraint(equalTo: menuCaption.trailingAnchor, constant: 12),
//            contentView.bottomAnchor.constraint(equalTo: menuCaption.bottomAnchor, constant: 4),
//            menuCaption.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//            ])
//    }
    
    @objc
    func menuCaptionTappped(sender: Any) {
        guard
            let characteristic = characteristic,
            let index = index else {
                return
        }
        
        delegate?.menuCaptionTapped(on: characteristic, at: index)
    }
}
