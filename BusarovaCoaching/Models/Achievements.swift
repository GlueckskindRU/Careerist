//
//  Achievements.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/01/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import Foundation

struct Achievements {
    let competenceID: String
    let competenceName: String
    let minProgress: Int
    let currentProgress: Int
    let maxProgress: Int
    
    init(competenceID: String, competenceName: String, minProgress: Int = 1, maxProgress: Int, currentProgress: Int) {
        self.competenceID = competenceID
        self.competenceName = competenceName
        self.minProgress = minProgress
        self.currentProgress = currentProgress
        self.maxProgress = maxProgress
    }
}
