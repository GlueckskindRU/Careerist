//
//  SubscriptionArticleSchedule.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

struct SubscriptionArticleSchedule: Codable {
    let frequency: DayOfWeek
    let hour: Int
    let minute: Int
    let withQuestions: Bool
    let shiftToUTC: Int
    
    enum CodingKeys: String, CodingKey {
        case frequency
        case hour
        case minute
        case withQuestions
        case shiftToUTC
    }
    
    init() {
        self.frequency = []
        self.hour = 0
        self.minute = 0
        self.withQuestions = false
        self.shiftToUTC = TimeZone.current.secondsFromGMT() / (60 * 60)
    }
    
    init(frequency: DayOfWeek, hour: Int, minute: Int, withQuestions: Bool) {
        self.frequency = frequency
        self.hour = hour
        self.minute = minute
        self.withQuestions = withQuestions
        self.shiftToUTC = TimeZone.current.secondsFromGMT() / (60 * 60)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let frequencyInt = try values.decode(Int.self, forKey: .frequency)
        self.frequency = DayOfWeek(rawValue: frequencyInt)
        
        self.hour = try values.decode(Int.self, forKey: .hour)
        self.minute = try values.decode(Int.self, forKey: .minute)
        self.withQuestions = try values.decode(Bool.self, forKey: .withQuestions)
        self.shiftToUTC = try values.decode(Int.self, forKey: .shiftToUTC)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(frequency.rawValue, forKey: .frequency)
        try container.encode(hour, forKey: .hour)
        try container.encode(minute, forKey: .minute)
        try container.encode(withQuestions, forKey: .withQuestions)
        try container.encode(shiftToUTC, forKey: .shiftToUTC)
    }
}

extension SubscriptionArticleSchedule: Equatable {
    static func ==(lhs: SubscriptionArticleSchedule, rhs: SubscriptionArticleSchedule) -> Bool {
        return lhs.frequency.rawValue == rhs.frequency.rawValue
            && lhs.hour == rhs.hour
            && lhs.minute == rhs.minute
            && lhs.withQuestions == rhs.withQuestions
            && lhs.shiftToUTC == rhs.shiftToUTC
    }
}
