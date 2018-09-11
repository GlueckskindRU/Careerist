//
//  StorageController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 11/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation
import Firebase

class StorageController {
    private let storage: Storage

    init() {
        self.storage = Storage.storage()
    }
}
