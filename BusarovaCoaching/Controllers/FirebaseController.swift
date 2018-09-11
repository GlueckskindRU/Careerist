//
//  FirebaseController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 11/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class FirebaseController {
    static let shared = FirebaseController()
    
    private init() { }
    
    private var _dataController: DataController!
    private var _storageController: StorageController!
    
    func setDataController(_ dataController: DataController) {
        _dataController = dataController
    }
    
    func setStorageController(_ storageController: StorageController) {
        _storageController = storageController
    }
    
    func getDataController() -> DataController {
        return _dataController
    }
    
    func getStorageController() -> StorageController {
        return _storageController
    }
}
