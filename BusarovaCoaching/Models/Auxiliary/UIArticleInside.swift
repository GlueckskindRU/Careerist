//
//  UIArticleInside.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 24/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

struct UIArticleInside: Hashable {
    let id: String
    let parentID: String
    var sequence: Int
    let type: ArticleInsideType
    let caption: String?
    let text: String?
    let image: UIImage?
    let imageURL: URL?
    let imageStorageURL: String?
    let imageName: String?
    var numeringList: Bool?
    var listElements: [String]?
    
    init(id: String, parentID: String, sequence: Int, type: ArticleInsideType, caption: String?, text: String?, image: UIImage?, imageURL: URL?, imageStorageURL: String?, imageName: String?, numericList: Bool?, listElements: [String]?) {
        self.id = id
        self.parentID = parentID
        self.sequence = sequence
        self.type = type
        self.caption = caption
        self.text = text
        self.image = image
        self.imageURL = imageURL
        self.imageStorageURL = imageStorageURL
        self.imageName = imageName
        self.numeringList = numericList
        self.listElements = listElements
    }
}
