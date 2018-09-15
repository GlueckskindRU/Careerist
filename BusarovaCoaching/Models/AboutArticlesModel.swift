//
//  AboutArticlesModel.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 29/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

struct AboutArticlesModel: Codable {
    let id: String
    let name: String
    let text: String
    
    init(id: String, name: String, text: String) {
        self.id = id
        self.name = name
        self.text = text
    }
}
