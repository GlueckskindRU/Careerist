//
//  ArticleNotes.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 18/03/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import Foundation

struct ArticleNotes: Codable {
    let id: String
    var notes: [String: [String: String]]
    
    enum CodingKeys: String, CodingKey {
        case id
        case notes
    }
    
    init(id: String) {
        self.id = id
        self.notes = [:]
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.notes = try values.decode([String: [String: String]].self, forKey: .notes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(notes, forKey: .notes)
    }
}
