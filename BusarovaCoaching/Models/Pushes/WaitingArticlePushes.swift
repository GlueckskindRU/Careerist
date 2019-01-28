//
//  WaitingArticlePushes.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/12/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

struct WaitingArticlePushes: Codable {
    let id: String
    var articles: Set<String>
    
    init(id: String) {
        self.id = id
        self.articles = []
    }
}
