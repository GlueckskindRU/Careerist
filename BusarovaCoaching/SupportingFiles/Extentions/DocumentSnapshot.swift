//
//  DocumentSnapshot.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension DocumentSnapshot {
    func toDocument<T: Decodable>(_ type: T.Type) throws -> T {
        return try JSONDecoder().decode(T.self, withJSONObject: (self.data() ?? [:]).byAdding(value: self.documentID, for: "id"))
    }
}
