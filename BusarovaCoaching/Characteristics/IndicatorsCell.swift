//
//  IndicatorsCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class IndicatorsCell: UITableViewCell {
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
        imageView.image = UIImage(named: Assets.whiteArrow.rawValue)
        
        return imageView
    }()
    
    lazy private var checkImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Assets.check.rawValue)
        
        return imageView
    }()
    
    lazy private var indicatorNameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return label
    }()
    
    func configure(with indicator: CharacteristicsModel, bgColor: UIColor) {
        smallBoxView.backgroundColor = bgColor
        indicatorNameLabel.text = indicator.name

        if AppManager.shared.isSubscribed(to: indicator) {
            arrowImageView.isHidden = true
            checkImageView.isHidden = false
        } else {
            arrowImageView.isHidden = false
            checkImageView.isHidden = true
        }
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
        smallBoxView.addSubview(indicatorNameLabel)
        smallBoxView.addSubview(arrowImageView)
        smallBoxView.addSubview(checkImageView)
        
        let leadingMargin: CGFloat = 16
        let topMargin: CGFloat = 8
        let trailingMargin: CGFloat = -16
        let extraTrailingMargin: CGFloat = -28
        let bottomMargin: CGFloat = -8
        
        NSLayoutConstraint.activate([
            smallBoxView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topMargin),
            smallBoxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingMargin),
            smallBoxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingMargin),
            smallBoxView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomMargin),
            
            indicatorNameLabel.topAnchor.constraint(equalTo: smallBoxView.topAnchor, constant: topMargin * 2),
            indicatorNameLabel.leadingAnchor.constraint(equalTo: smallBoxView.leadingAnchor, constant: leadingMargin),
            indicatorNameLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: extraTrailingMargin),
            indicatorNameLabel.trailingAnchor.constraint(equalTo: checkImageView.leadingAnchor, constant: trailingMargin),
            indicatorNameLabel.bottomAnchor.constraint(equalTo: smallBoxView.bottomAnchor, constant: bottomMargin * 2),
            indicatorNameLabel.centerYAnchor.constraint(equalTo: smallBoxView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: smallBoxView.trailingAnchor, constant: trailingMargin),
            arrowImageView.centerYAnchor.constraint(equalTo: smallBoxView.centerYAnchor),
            
            checkImageView.trailingAnchor.constraint(equalTo: smallBoxView.trailingAnchor, constant: trailingMargin),
            checkImageView.centerYAnchor.constraint(equalTo: smallBoxView.centerYAnchor),
            
            arrowImageView.heightAnchor.constraint(equalToConstant: 12),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            
            checkImageView.heightAnchor.constraint(equalToConstant: 24),
            checkImageView.widthAnchor.constraint(equalToConstant: 24),
            ])
    }
}
