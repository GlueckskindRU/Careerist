//
//  ListOfArticlesCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/12/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ListOfArticlesCell: UITableViewCell {
    private let cornerRadius: CGFloat = 8
    
    lazy private var smallBoxView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "cabinetTintColor")
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
    
    lazy private var markImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    func configure(with asset: ReceivedAsset, as sequence: Int) {
        captionLabel.text = asset.asset.title.isEmpty ? "Статья № \(sequence)" : asset.asset.title
        
        if !asset.wasRead {
            arrowImageView.isHidden = true
            markImageView.isHidden = false
        } else {
            arrowImageView.isHidden = false
            markImageView.isHidden = true
        }
        
        if asset.hasQuestions {
            if asset.wasRead && asset.passed {
                markImageView.image = UIImage(named: Assets.check.rawValue)
            } else {
                markImageView.image = UIImage(named: Assets.exclamationMark.rawValue)
            }
        } else {
            if asset.wasRead {
                markImageView.image = UIImage(named: Assets.check.rawValue)
            } else {
                markImageView.image = UIImage(named: Assets.exclamationMark.rawValue)
            }
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
        smallBoxView.addSubview(captionLabel)
        smallBoxView.addSubview(arrowImageView)
        smallBoxView.addSubview(markImageView)
        
        let leadingMargin: CGFloat = 16
        let topMargin: CGFloat = 8
        let trailingMargin: CGFloat = -16
        let extraTrailingMargin: CGFloat = -22
        let bottomMargin: CGFloat = -8
        let arrowSize: CGFloat = 12
        let markSize: CGFloat = 24
        
        NSLayoutConstraint.activate([
            smallBoxView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topMargin),
            smallBoxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingMargin),
            smallBoxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingMargin),
            smallBoxView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomMargin),
            
            captionLabel.topAnchor.constraint(equalTo: smallBoxView.topAnchor, constant: topMargin * 2),
            captionLabel.leadingAnchor.constraint(equalTo: smallBoxView.leadingAnchor, constant: leadingMargin),
            captionLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: extraTrailingMargin),
            captionLabel.trailingAnchor.constraint(equalTo: markImageView.leadingAnchor, constant: trailingMargin),
            captionLabel.bottomAnchor.constraint(equalTo: smallBoxView.bottomAnchor, constant: bottomMargin * 2),
            captionLabel.centerYAnchor.constraint(equalTo: smallBoxView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: smallBoxView.trailingAnchor, constant: extraTrailingMargin),
            arrowImageView.centerYAnchor.constraint(equalTo: smallBoxView.centerYAnchor),
            
            markImageView.trailingAnchor.constraint(equalTo: smallBoxView.trailingAnchor, constant: trailingMargin),
            markImageView.centerYAnchor.constraint(equalTo: smallBoxView.centerYAnchor),
            
            arrowImageView.heightAnchor.constraint(equalToConstant: arrowSize),
            arrowImageView.widthAnchor.constraint(equalToConstant: arrowSize),
            
            markImageView.heightAnchor.constraint(equalToConstant: markSize),
            markImageView.widthAnchor.constraint(equalToConstant: markSize),
            ])
    }
}
