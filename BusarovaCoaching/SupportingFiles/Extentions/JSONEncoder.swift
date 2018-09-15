//
//  JSONEncoder.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

extension JSONEncoder {
    func encodeSerialized<T: Encodable>(_ value: T) throws -> [String: Any] {
        let data = try encode(value)
        let result = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        return result
    }
}
