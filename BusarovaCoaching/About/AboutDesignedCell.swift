//
//  AboutDesignedCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 07/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class AboutDesignedCell: UITableViewCell {
    lazy private var menuBoxImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        return imageView
    }()
    
    func configure(with image: UIImage?) {
        self.menuBoxImageView.image = image
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
        contentView.addSubview(menuBoxImageView)
        
        NSLayoutConstraint.activate([
            menuBoxImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            menuBoxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            menuBoxImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            menuBoxImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            ])
    }
}
