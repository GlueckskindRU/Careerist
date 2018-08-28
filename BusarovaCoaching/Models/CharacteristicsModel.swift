//
//  CharacteristicsModel.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 27/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

struct CharacteristicsModel: Codable {
    let id: String
    let name: String
    let parentID: String
    var collapsed: Bool
    let level: Int
    
    init(id: String, name: String, parentID: String, level: Int) {
        self.id = id
        self.name = name
        self.parentID = parentID
        self.level = level
        self.collapsed = true
    }
}
