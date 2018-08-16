//
//  CabinetSectionView.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

protocol CabinetSectionDelegateProtocol {
    func pushViewController(with title: String)
}

class CabinetSectionView: UIView {
    private var delegate: CabinetSectionDelegateProtocol?
    
    lazy private var menuCaption: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(menuCaptionTappped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    func configure(with menuCaption: String, as delegate: CabinetSectionDelegateProtocol) {
        self.menuCaption.setTitle(menuCaption, for: .normal)
        self.delegate = delegate
        
        addSubview(self.menuCaption)
    }
    
    @objc
    private func menuCaptionTappped(sender: Any) {
        guard let title = menuCaption.titleLabel?.text else {
            return
        }
        delegate?.pushViewController(with: title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
//            safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50),
            menuCaption.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            menuCaption.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 4),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: menuCaption.trailingAnchor, constant: 4),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: menuCaption.bottomAnchor, constant: 4)
            ])
    }
}
