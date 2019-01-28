//
//  AchivementsCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import Kingfisher

class AchivementsCell: UITableViewCell {
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var achievementNameLabel: UILabel!

    func configure(with achievement: Achievements) {
        achievementNameLabel.text = achievement.competenceName
        progressView.minimumProgress = achievement.minProgress
        progressView.maximumProgress = achievement.maxProgress
        progressView.currentProgress = achievement.currentProgress
        progressView.progressedColor = UIColor.orange
        progressView.unprogressedColor = UIColor.lightGray
    }
}
