//
//  AchievementsModel.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 28/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

struct AchievementsModel: Codable {
    let id: String
    let name: String
    let imageURL: String
    
    init(id: String, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
}
