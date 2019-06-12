//
//  CompetenciesCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 04/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class CompetenciesCell: UITableViewCell {
    private let cornerRadius: CGFloat = 8
    
    lazy private var smallBoxView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let shadowColor = UIColor(named: "boxesShadow")
        view.layer.shadowColor = shadowColor?.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = cornerRadius
        view.layer.cornerRadius = cornerRadius
        
        return view
    }()
    
    lazy private var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "whiteArrow")
        
        return imageView
    }()
    
    lazy private var competenceNameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return label
    }()
    
    func configure(with name: String, bgColor: UIColor) {
        smallBoxView.backgroundColor = bgColor
        competenceNameLabel.text = name
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
        contentView.addSubview(smallBoxView)
        smallBoxView.addSubview(competenceNameLabel)
        smallBoxView.addSubview(arrowImageView)
        
        let leadingMargin: CGFloat = 16
        let topMargin: CGFloat = 8
        let trailingMargin: CGFloat = -16
        let bottomMargin: CGFloat = -8
        let arrowSize: CGFloat = 12
        
        NSLayoutConstraint.activate([
            smallBoxView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topMargin),
            smallBoxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingMargin),
            smallBoxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingMargin),
            smallBoxView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomMargin),
            
            competenceNameLabel.topAnchor.constraint(equalTo: smallBoxView.topAnchor, constant: topMargin * 2),
            competenceNameLabel.leadingAnchor.constraint(equalTo: smallBoxView.leadingAnchor, constant: leadingMargin),
            competenceNameLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: trailingMargin),
            competenceNameLabel.bottomAnchor.constraint(equalTo: smallBoxView.bottomAnchor, constant: bottomMargin * 2),
            competenceNameLabel.centerYAnchor.constraint(equalTo: smallBoxView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: smallBoxView.trailingAnchor, constant: trailingMargin),
            arrowImageView.centerYAnchor.constraint(equalTo: smallBoxView.centerYAnchor),
            
            arrowImageView.widthAnchor.constraint(equalToConstant: arrowSize),
            arrowImageView.heightAnchor.constraint(equalToConstant: arrowSize),
            ])
    }
}
