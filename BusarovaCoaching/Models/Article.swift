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
}
