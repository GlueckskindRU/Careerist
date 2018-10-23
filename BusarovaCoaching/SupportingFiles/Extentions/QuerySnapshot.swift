//
//  QuerySnapshot.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension QuerySnapshot {
    func documentsToList<T: Decodable>(_ type: T.Type) throws -> [T] {
        return try documents.map { try $0.toDocument(T.self) }
    }
}
