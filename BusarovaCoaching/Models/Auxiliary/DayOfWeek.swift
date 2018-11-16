//
//  DayOfWeek.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

struct DayOfWeek: OptionSet {
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let monday = DayOfWeek(rawValue: 1 << 0)
    static let tuesday = DayOfWeek(rawValue: 1 << 1)
    static let wednesday = DayOfWeek(rawValue: 1 << 2)
    static let thursday = DayOfWeek(rawValue: 1 << 4)
    static let friday = DayOfWeek(rawValue: 1 << 8)
    static let saturday = DayOfWeek(rawValue: 1 << 16)
    static let sunday = DayOfWeek(rawValue: 1 << 32)
    
    var description: String {
        return "DayOfWeek = \(rawValue)"
    }
}
