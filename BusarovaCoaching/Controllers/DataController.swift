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

typealias DataBaseClosure = ([QueryDocumentSnapshot]) -> Void

class DataController {
    private var db: Firestore
    
    init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
    }
    
// MARK: - Characteristics
    func fetchInitialCharacteristics(completion: @escaping DataBaseClosure) {
        db.collection(DBTables.characteristics.rawValue).whereField("level", isEqualTo: 0).order(by: "name").getDocuments() {
                (snap, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    completion(snap!.documents)
                }
            }
    }
    
    func fetchChildernCharacteristicsOf(_ parentID: String, completion: @escaping DataBaseClosure) {
        db.collection(DBTables.characteristics.rawValue).whereField("parentID", isEqualTo: parentID).order(by: "name").getDocuments() {
            (snap, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                completion(snap!.documents)
            }
        }
    }
    
// MARK: - Achievements
    func fetchAchievements(completion: @escaping DataBaseClosure) {
        db.collection(DBTables.achivements.rawValue).order(by: "name").getDocuments() {
            (snap, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                completion(snap!.documents)
            }
        }
    }
    
// MARK: - Notes
    func fetchNotes(completion: @escaping DataBaseClosure) {
        db.collection(DBTables.notes.rawValue).order(by: "name").getDocuments() {
            (snap, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                completion(snap!.documents)
            }
        }
    }
    
// MARK: - universal
    func fetchData(_ from: DBTables, completion: @escaping DataBaseClosure) {
        db.collection(from.rawValue).order(by: "name").getDocuments() {
            (snap, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                completion(snap!.documents)
            }
        }
    }
}
