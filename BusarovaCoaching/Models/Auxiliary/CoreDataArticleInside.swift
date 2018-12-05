//
//  CoreDataArticleInside.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 24/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CoreDataArticleInside {
    let id: String
    let parentID: String
    let type: Int16
    let sequence: Int16
    let caption: String?
    let image: UIImage?
    let imageName: String?
    let numericList: Bool?
    let text: String?
    
    init(id: String, parentID: String, type: Int, sequence: Int, caption: String?, image: UIImage?, imageName: String?, numericList: Bool?, text: String?) {
        self.id = id
        self.parentID = parentID
        self.type = Int16(type)
        self.sequence = Int16(sequence)
        self.caption = caption
        self.image = image
        self.imageName = imageName
        self.numericList = numericList
        self.text = text
    }
}
