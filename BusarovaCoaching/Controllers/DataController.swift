//
//  DataController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 27/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class DataController {
    private var db: Firestore
    
    init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
    }
    
    func fetchInitialCharacteristics(completion: @escaping ([QueryDocumentSnapshot]) -> Void) {
        db.collection(DBTables.characteristics.rawValue).whereField("level", isEqualTo: 0).order(by: "name").getDocuments() {
                (snap, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    completion(snap!.documents)
                }
            }
    }
    
    func fetchChildernCharacteristicsOf(_ parentID: String, completion: @escaping ([QueryDocumentSnapshot]) -> Void) {
        db.collection(DBTables.characteristics.rawValue).whereField("parentID", isEqualTo: parentID).order(by: "name").getDocuments() {
            (snap, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                completion(snap!.documents)
            }
        }
    }
}
