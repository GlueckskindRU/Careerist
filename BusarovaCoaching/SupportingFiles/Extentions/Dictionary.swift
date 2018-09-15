//
//  Dictionary.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

extension Dictionary {
    func byAdding(value: Value, for key: Key) -> Dictionary {
        var result = self
        result[key] = value
        return result
    }
}
