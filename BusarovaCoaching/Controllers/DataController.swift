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
        db = Firestore.firestore()
    }
    
// MARK: - Characteristics
    func fetchInitialCharacteristics<T: Codable>(completion: @escaping (Result<[T]>) -> Void) {
        db.collection(DBTables.characteristics.rawValue).whereField("level", isEqualTo: 0).order(by: "name").getDocuments() {
            (snap, error) in
            guard let snap = snap, !snap.isEmpty else {
                if let error = error {
                    completion(Result.failure(.otherError(error)))
                } else {
                    completion(Result.success([]))
                }
                return
            }
            
            do {
                let result = try snap.documentsToList(T.self)
                completion(Result.success(result))
            } catch {
                completion(Result.failure(.otherError(error)))
            }
        }
    }
    
    func fetchChildernCharacteristicsOf<T: Codable>(_ parentID: String, completion: @escaping (Result<[T]>) -> Void) {
        db.collection(DBTables.characteristics.rawValue).whereField("parentID", isEqualTo: parentID).order(by: "name").getDocuments() {
            (snap, error) in
            
            guard let snap = snap, !snap.isEmpty else {
                if let error = error {
                    completion(Result.failure(.otherError(error)))
                } else {
                    completion(Result.success([]))
                }
                return
            }
            
            do {
                let result = try snap.documentsToList(T.self)
                completion(Result.success(result))
            } catch {
                completion(Result.failure(.otherError(error)))
            }
        }
    }
    
// MARK: - universal
    func fetchData<T: Codable>(_ from: DBTables, completion: @escaping (Result<[T]>) -> Void) {
        db.collection(from.rawValue).order(by: "name").getDocuments() {
            (snap, error) in
            
            guard let snap = snap, !snap.isEmpty else {
                if let error = error {
                    completion(Result.failure(.otherError(error)))
                } else {
                    completion(Result.success([]))
                }
                return
            }
            
            do {
                let result = try snap.documentsToList(T.self)
                completion(Result.success(result))
            } catch {
                completion(Result.failure(.otherError(error)))
            }
        }
    }
    
    func saveData<T: Codable>(_ element: T, with identifier: String?, in table: DBTables, completion: @escaping (Result<T>) -> Void) {
        let docReference: DocumentReference
        
        if let identifier = identifier {
            docReference = db.collection(table.rawValue).document(identifier)
        } else {
            docReference = db.collection(table.rawValue).document()
        }
        
        do {
            var outputDocument = try JSONEncoder().encodeSerialized(element)
            _ = outputDocument.removeValue(forKey: "id")
            
            docReference.setData(outputDocument) {
                (error) in
                
                if let error = error {
                    print("Error writing document: \(error)")
                    completion(Result.failure(.saveDocument(error)))
                } else {
                    self.db.collection(table.rawValue).document(docReference.documentID).getDocument() {
                        (snap, error) in
                        
                        guard let snap = snap, snap.exists else {
                                if let error = error {
                                    completion(Result.failure(.fetchDocument(error)))
                                } else {
                                    completion(Result.failure(.documentNotFound(docReference.documentID)))
                                }
                                return
                        }
                        
                        do {
                            let result = try snap.toDocument(T.self)
                            
                            completion(Result.success(result))
                        } catch {
                            completion(Result.failure(.fetchDocument(error)))
                        }
                    }
                }
            }
            
        } catch {
            completion(Result.failure(error as! AppError))
        }
    }
    
// MARK: - articles
    func fetchArticles<T: Codable>(from: DBTables, by parentID: String, completion: @escaping (Result<[T]>) -> Void) {
        db.collection(DBTables.articles.rawValue).whereField("parentType", isEqualTo: from.rawValue).whereField("parentID", isEqualTo: parentID).order(by: "sequence").getDocuments() {
            (snap, error) in
            
            guard let snap = snap, !snap.isEmpty else {
                if let error = error {
                    completion(Result.failure(.otherError(error)))
                } else {
                    completion(Result.success([]))
                }
                return
            }
            
            do {
                let result = try snap.documentsToList(T.self)
                completion(Result.success(result))
            } catch {
                completion(Result.failure(.otherError(error)))
            }
        }
    }
    
    func fetchArticle<T: Codable>(with parentID: String, completion: @escaping (Result<[T]>) -> Void) {
        db.collection(DBTables.articlesInside.rawValue).whereField("parentID", isEqualTo: parentID).order(by: "sequence").getDocuments() {
            (snap, error) in
            
            guard let snap = snap, !snap.isEmpty else {
                if let error = error {
                    completion(Result.failure(.otherError(error)))
                } else {
                    completion(Result.success([]))
                }
                return
            }
            
            do {
                let result = try snap.documentsToList(T.self)
                completion(Result.success(result))
            } catch {
                completion(Result.failure(.otherError(error)))
            }
        }
    }
}
