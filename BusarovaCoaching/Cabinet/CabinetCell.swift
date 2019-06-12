//
//  CabinetCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CabinetCell: UITableViewCell {
    lazy private var boxImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Assets.cabinetBox.rawValue)
        
        return imageView
    }()
    
    lazy private var captionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return label
    }()
    
    lazy private var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Assets.whiteArrow.rawValue)
        
        return imageView
    }()
    
    func configure(with caption: String) {
        captionLabel.text = caption
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
        contentView.addSubview(boxImageView)
        boxImageView.addSubview(captionLabel)
        boxImageView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            boxImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            boxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            boxImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            boxImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            captionLabel.topAnchor.constraint(equalTo: boxImageView.topAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: boxImageView.leadingAnchor, constant: 36),
            captionLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            captionLabel.bottomAnchor.constraint(equalTo: boxImageView.bottomAnchor, constant: -8),
            captionLabel.centerYAnchor.constraint(equalTo: boxImageView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: boxImageView.trailingAnchor, constant: -36),
            arrowImageView.centerYAnchor.constraint(equalTo: boxImageView.centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 12),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            ])
    }
}
