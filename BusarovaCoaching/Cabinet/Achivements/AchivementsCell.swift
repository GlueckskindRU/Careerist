//
//  AchivementsCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class AchivementsCell: UITableViewCell {
    lazy private var achiveCaption: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy private var pictureView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    func configure(with achieve: String) {
        self.achiveCaption.text = achieve
        self.pictureView.image = UIImage(named: "About")
        
        contentView.addSubview(achiveCaption)
        contentView.addSubview(pictureView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 40),
            pictureView.heightAnchor.constraint(equalToConstant: 40),
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            pictureView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            achiveCaption.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: achiveCaption.trailingAnchor, constant: 12),
            achiveCaption.centerYAnchor.constraint(equalTo: pictureView.centerYAnchor)
            ])
        
        achiveCaption.sizeToFit()
    }
}