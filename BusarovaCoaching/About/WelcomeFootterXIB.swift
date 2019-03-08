//
//  WelcomeFootterXIB.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 15/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import YoutubePlayerView

class WelcomeFootterXIB: UIView {
    @IBOutlet weak var leftPlayerView: YoutubePlayerView!
    @IBOutlet weak var rightPlayerView: YoutubePlayerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        let leftVideoID = "BtqNG7AVXN0" //Как быть убедительным: аргументация и контраргументация. Наталья Бусарова | Courson | Курсон
        let rightVideoID = "g4eZ0LzjZ5I" //Мастер-класс Натальи Бусаровой
//        leftPlayerView.load(withVideoId: leftVideoID)
//        rightPlayerView.load(withVideoId: rightVideoID)
        leftPlayerView.loadWithVideoId(leftVideoID)
        rightPlayerView.loadWithVideoId(rightVideoID)
    }
}
