//
//  Article.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 12/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

struct Article: Codable, Hashable {
    let id: String
    let title: String
    let parentID: String
    let parentType: String
    var sequence: Int
    let grants: Int
    let authorID: String
    let rating: Int
    let verified: Bool
    let type: ArticleType
    let competenceID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case parentID
        case parentType
        case sequence
        case grants
        case authorID
        case rating
        case verified
        case type
        case competenceID
    }
    
    init(id: String, title: String, parentID: String, parentType: String, sequence: Int, grants: Int, authorID: String, rating: Int, verified: Bool, type: ArticleType, competenceID: String) {
        self.id = id
        self.title = title
        self.parentID = parentID
        self.parentType = parentType
        self.sequence = sequence
        self.grants = grants
        self.authorID = authorID
        self.rating = rating
        self.verified = verified
        self.type = type
        self.competenceID = competenceID
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.title = try values.decode(String.self, forKey: .title)
        self.parentID = try values.decode(String.self, forKey: .parentID)
        self.parentType = try values.decode(String.self, forKey: .parentType)
        self.sequence = try values.decode(Int.self, forKey: .sequence)
        self.grants = try values.decode(Int.self, forKey: .grants)
        self.authorID = try values.decode(String.self, forKey: .authorID)
        self.rating = try values.decode(Int.self, forKey: .rating)
        self.verified = try values.decode(Bool.self, forKey: .verified)
        self.competenceID = try values.decode(String.self, forKey: .competenceID)
        
        let typeInt = try values.decode(Int.self, forKey: .type)
        if let type = ArticleType(rawValue: typeInt) {
            self.type = type
        } else {
            self.type = .article
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(parentID, forKey: .parentID)
        try container.encode(parentType, forKey: .parentType)
        try container.encode(sequence, forKey: .sequence)
        try container.encode(grants, forKey: .grants)
        try container.encode(authorID, forKey: .authorID)
        try container.encode(rating, forKey: .rating)
        try container.encode(verified, forKey: .verified)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(competenceID, forKey: .competenceID)
    }
}
