//
//  OldNotesCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class OldNotesCell: UITableViewCell {
    lazy private var cellCaption: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    func configure(with note: NotesModel) {
        cellCaption.text = note.name
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutInit()
    }
    
    private func layoutInit() {
        contentView.addSubview(cellCaption)
        
        NSLayoutConstraint.activate([
            cellCaption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cellCaption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cellCaption.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
    }
}
