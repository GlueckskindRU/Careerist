//
//  VideoCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 07/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit
import YoutubePlayerView

class VideoCell: UITableViewCell {
    @IBOutlet weak var videoView: YoutubePlayerView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with videoId: String) {
        videoView.loadWithVideoId(videoId)
    }
}
