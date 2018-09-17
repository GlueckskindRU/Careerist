//
//  ArticleInside.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 12/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

struct ArticleInside: Codable {
    let id: String
    let parentID: String
    let sequence: Int
    let type: ArticleInsideType
    let caption: String?
    let text: String?
    let imageURL: URL?
    let imageName: String?
    var numericList: Bool?
    let listElements: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case parentID
        case sequence
        case type
        case caption
        case text
        case imageURL
        case imageName
        case numericList
        case listElements
    }
    
    init?(id: String, parentID: String, sequence: Int, type: Int, caption: String?, text: String?, imageURL: URL?, imageName: String?, numericList: Bool?, listElements: [String]?) {
        self.id = id
        self.parentID = parentID
        self.sequence = sequence
        guard let articteInsideType = ArticleInsideType(rawValue: type) else {
            return nil
        }
        self.type = articteInsideType
        self.caption = caption
        self.text = text
        self.imageURL = imageURL
        self.imageName = imageName
        self.numericList = numericList
        self.listElements = listElements
    }
    
    init(id: String, parentID: String, sequence: Int, type: ArticleInsideType, caption: String?, text: String?, imageURL: URL?, imageName: String?, numericList: Bool?, listElements: [String]?) {
        self.id = id
        self.parentID = parentID
        self.sequence = sequence
        self.type = type
        self.caption = caption
        self.text = text
        self.imageURL = imageURL
        self.imageName = imageName
        self.numericList = numericList
        self.listElements = listElements
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.parentID = try values.decode(String.self, forKey: .parentID)
        self.sequence = try values.decode(Int.self, forKey: .sequence)
        
        let typeInt = try values.decode(Int.self, forKey: .type)
        self.type = ArticleInsideType(rawValue: typeInt)!
        self.caption = try? values.decode(String.self, forKey: .caption)
        self.text = try? values.decode(String.self, forKey: .text)
        self.imageURL = try? values.decode(URL.self, forKey: .imageURL)
        self.imageName = try? values.decode(String.self, forKey: .imageName)
        self.numericList = try? values.decode(Bool.self, forKey: .numericList)
        self.listElements = try? values.decode([String].self, forKey: .listElements)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(parentID, forKey: .parentID)
        try container.encode(sequence, forKey: .sequence)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(caption, forKey: .caption)
        try container.encode(text, forKey: .text)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(numericList, forKey: .numericList)
        try container.encode(listElements, forKey: .listElements)
    }
}
