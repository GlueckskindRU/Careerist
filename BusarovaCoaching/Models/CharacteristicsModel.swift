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
    let level: CharacteristicsLevel
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case parentID
        case collapsed
        case level
    }
    
    init(id: String, name: String, parentID: String, level: CharacteristicsLevel) {
        self.id = id
        self.name = name
        self.parentID = parentID
        self.level = level
        self.collapsed = true
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.parentID = try values.decode(String.self, forKey: .parentID)
        self.collapsed = try values.decode(Bool.self, forKey: .collapsed)
        
        let levelInt = try values.decode(Int.self, forKey: .level)
        self.level = CharacteristicsLevel(rawValue: levelInt)!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(parentID, forKey: .parentID)
        try container.encode(collapsed, forKey: .collapsed)
        try container.encode(level.rawValue, forKey: .level)
    }
}
