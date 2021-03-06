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
    var subscribedCharacteristics: [String: Set<String>]
    let fcmToken: String
    var rating: Set<PassedQuestions>
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case userRole
        case isPaidUser
        case hasPaidTill
        case subscribedCharacteristics
        case fcmToken
        case rating
    }
    
    init(name: String, email: String) {
        self.init(id: "", name: name, email: email, role: UserRole.user, isPaidUser: false, hasPaidTill: nil, subscribedCharacteristics: [:], fcmToken: "", rating: [])
    }
    
    init(id: String, name: String, email: String) {
        self.init(id: id, name: name, email: email, role: UserRole.user, isPaidUser: false, hasPaidTill: nil, subscribedCharacteristics: [:], fcmToken: "", rating: [])
    }
    
    init(id: String, name: String, email: String, role: UserRole, isPaidUser: Bool, hasPaidTill: Date?, subscribedCharacteristics: [String: Set<String>], fcmToken: String, rating: Set<PassedQuestions>) {
        self.id = id
        self.name = name
        self.email = email
        self.userRole = role
        self.isPaidUser = isPaidUser
        self.hasPaidTill = hasPaidTill
        self.subscribedCharacteristics = subscribedCharacteristics
        self.fcmToken = fcmToken
        self.rating = rating
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
        self.subscribedCharacteristics = try values.decode([String: Set<String>].self, forKey: .subscribedCharacteristics)
        self.fcmToken = try values.decode(String.self, forKey: .fcmToken)
        self.rating = try values.decode(Set<PassedQuestions>.self, forKey: .rating)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(userRole.rawValue, forKey: .userRole)
        try container.encode(isPaidUser, forKey: .isPaidUser)
        try container.encode(hasPaidTill, forKey: .hasPaidTill)
        try container.encode(subscribedCharacteristics, forKey: .subscribedCharacteristics)
        try container.encode(fcmToken, forKey: .fcmToken)
        try container.encode(rating, forKey: .rating)
    }
}
