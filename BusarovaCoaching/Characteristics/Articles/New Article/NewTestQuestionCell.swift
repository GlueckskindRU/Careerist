//
//  NewTestQuestionCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 01/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class NewTestQuestionCell: UITableViewCell {
    lazy private var numberLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        
        return label
    }()
    
    lazy private var answeringOptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    func configure(number: String, answer: String, isCorrectAnswer: Bool) {
        numberLabel.text = number
        answeringOptionLabel.text = answer
        
        if isCorrectAnswer {
            contentView.backgroundColor = .lightGray
        } else {
            contentView.backgroundColor = .white
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.showsReorderControl = true
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(answeringOptionLabel)
        
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            numberLabel.widthAnchor.constraint(equalToConstant: 24),
            
            answeringOptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            answeringOptionLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: answeringOptionLabel.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: answeringOptionLabel.bottomAnchor, constant: 16)
            ])
    }
}
