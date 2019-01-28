//
//  Date.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/01/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import Foundation

extension Date {
    var dateWithTimeFormatting: String {
        let formatter = DateFormatter()
        let locale = Locale(identifier: "ru_RU")
        formatter.locale = locale
        formatter.dateFormat = "dd.MM.yy h:mm"
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    var dateFormatting: String {
        let formatter = DateFormatter()
        let locale = Locale(identifier: "ru_RU")
        formatter.locale = locale
        formatter.dateFormat = "dd.MM.yy"
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
