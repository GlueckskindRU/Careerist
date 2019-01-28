//
//  AnswersCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 10/01/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class AnswersCell: UITableViewCell {
    lazy private var answerLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.backgroundColor = UIColor.white
        
        return label
    }()
    
    func configure(with answer: String) {
        answerLabel.text = answer
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
        contentView.addSubview(answerLabel)
        
        NSLayoutConstraint.activate([
            answerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            answerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            contentView.trailingAnchor.constraint(equalTo: answerLabel.trailingAnchor, constant: 32),
            contentView.bottomAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 8),
            ])
    }
}
