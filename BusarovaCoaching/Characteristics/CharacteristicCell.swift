//
//  CharacteristicCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 01/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class CharacteristicCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var blockImageView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    func configure(title: String, info: String, block: UIImage, arrow: UIImage) {
        titleLabel.text = title
        infoLabel.text = info
        blockImageView.image = block
        arrowImageView.image = arrow
        infoLabel.sizeToFit()
    }
}
