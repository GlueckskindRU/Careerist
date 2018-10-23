//
//  User.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 22/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let userRole: UserRole
    let isPaidUser: Bool
    let hasPaidTill: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case userRole
        case isPaidUser
        case hasPaidTill
    }
    
    init(name: String, email: String) {
        self.init(id: "", name: name, email: email, role: UserRole.user, isPaidUser: false, hasPaidTill: nil)
    }
    
    init(id: String, name: String, email: String) {
        self.init(id: id, name: name, email: email, role: UserRole.user, isPaidUser: false, hasPaidTill: nil)
    }
    
    init(id: String, name: String, email: String, role: UserRole, isPaidUser: Bool, hasPaidTill: Date?) {
        self.id = id
        self.name = name
        self.email = email
        self.userRole = role
        self.isPaidUser = isPaidUser
        self.hasPaidTill = hasPaidTill
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.email = try values.decode(String.self, forKey: .email)
        
        let roleInt = try values.decode(Int.self, forKey: .userRole)
        self.userRole = UserRole(rawValue: roleInt)!
        
        self.isPaidUser = try values.decode(Bool.self, forKey: .isPaidUser)
        self.hasPaidTill = try? values.decode(Date.self, forKey: .hasPaidTill)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(userRole.rawValue, forKey: .userRole)
        try container.encode(isPaidUser, forKey: .isPaidUser)
        try container.encode(hasPaidTill, forKey: .hasPaidTill)
    }
}
