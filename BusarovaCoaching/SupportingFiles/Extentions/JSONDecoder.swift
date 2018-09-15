//
//  JSONDecoder.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

extension JSONDecoder {
    func decode<T>(_ type: T.Type, withJSONObject: Any) throws -> T where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: withJSONObject, options: [])
        let result = try decode(T.self, from: data)
        return result
    }
}
