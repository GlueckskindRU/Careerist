//
//  NotesCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 20/03/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {
    lazy private var noteTitleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    func configure(with title: String) {
        noteTitleLabel.text = title
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layoutSetup()
    }
    
    private func layoutSetup() {
        contentView.addSubview(noteTitleLabel)
        
        NSLayoutConstraint.activate([
            noteTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            noteTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: noteTitleLabel.trailingAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 8),
            ])
    }
}
