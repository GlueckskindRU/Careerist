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
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
// MARK: - Characteristics
    /// Fetches array of charachteristics depending of their level.
    ///
    /// - Parameter level: desribes the level of a Characteristic.
    /// - Parameter completion: completion closure: (Result<[Codable]>) -> Void.
    func fetchCharacteristics<T: Codable>(of level: CharacteristicsLevel, completion: @escaping (Result<[T]>) -> Void) {
        db.collection(DBTables.characteristics.rawValue).whereField("level", isEqualTo: level.rawValue).order(by: "name").getDocuments() {
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
    
    /// Fetches array of childern characteristics depending on their parentID.
    ///
    /// - Parameter parentID: parents identifier of a requested characteristics
    /// - Parameter completion: completion closure: (Result<[Codable]>) -> Void
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
    /// Universal method to fetch array of documents of any type.
    /// Result is sorted by the "name" field.
    ///
    /// - Parameter from: value of a DBTables enum, represents the firebase collection
    /// - Parameter completion: completion closure: (Result<[Codable]>) -> Void
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
    
    /// Universal method to fetch a document of any type.
    ///
    /// - Parameter identifier: identifier of a requested document
    /// - Parameter from: value of a DBTables enum, represents the firebase collection
    /// - Parameter completion: completion closure: (Result < Codable > ) -> Void
    func fetchData<T: Codable>(with identifier: String, from: DBTables, completion: @escaping (Result<T>) -> Void) {
        db.collection(from.rawValue).document(identifier).getDocument() {
            (snap, error) in
            
            guard let snap = snap else {
                if let error = error {
                    completion(Result.failure(AppError.otherError(error)))
                } else {
                    completion(Result.failure(AppError.documentNotFound(identifier)))
                }
                return
            }
            
            do {
                let result = try snap.toDocument(T.self)
                completion(Result.success(result))
            } catch {
                completion(Result.failure(.otherError(error)))
            }
        }
    }
    
    /// Universal method to save a document of any type.
    ///
    /// - Parameter element: the element to save, should conform to the Codable protocol
    /// - Parameter with: identifier of a saved element. If is unknown = nil
    /// - Parameter in: value of a DBTables enum, represents the firebase collection where the element should be saved
    /// - Parameter completion: completion closure: (Result < Codable > ) -> Void
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
    
    /// Universal method for deletion a document of any type.
    ///
    /// - Parameter with: identifier of a deleted document
    /// - Parameter from: value of a DBTables enum, represents the firebase collection where the document should be deleted
    /// - Parameter completion: completion closure: (Result < Bool > ) -> Void
    func deleteData(with identifier: String, from table: DBTables, completion: @escaping (Result<Bool>) -> Void) {
        db.collection(table.rawValue).document(identifier).delete() {
            error in
            
            if let error = error {
                completion(Result.failure(.otherError(error)))
            } else {
                completion(Result.success(true))
            }
        }
    }
    
// MARK: - articles
    /// Fetches articles according to passed parameters: parentID and parentType
    ///
    /// - Parameter from: value of a DBTables enum, represents the firebase collection
    /// - Parameter by: parents identifier
    /// - Parameter completion: completion closure: (Result<[Codable]>) -> Void
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
    
    /// Fetches ArticleInside according to passed parentID.
    ///
    /// - Parameter with: parents identifier
    /// - Parameter forPreview: if is **true** all test questions will be skiped. If is **false** all related articleInside elements will be fetched
    /// - Parameter completion: completion closure: Result<[ArticleInside]>) -> Void
    func fetchArticle(with parentID: String, forPreview: Bool, completion: @escaping (Result<[ArticleInside]>) -> Void) {
        if forPreview {
            fetchArticleForPreview(with: parentID, completion: completion)
        } else {
            fetchArticleFull(with: parentID, completion: completion)
        }
    }
    
    private func fetchArticleForPreview(with parentID: String, completion: @escaping (Result<[ArticleInside]>) -> Void) {
        db.collection(DBTables.articlesInside.rawValue).whereField("parentID", isEqualTo: parentID).whereField("type", isLessThan: ArticleInsideType.testQuestion.rawValue).order(by: "type").getDocuments() {
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
                let result = try snap.documentsToList(ArticleInside.self).sorted( by: { $0.sequence < $1.sequence } )
                completion(Result.success(result))
            } catch {
                completion(Result.failure(.otherError(error)))
            }
        }
    }
    
    private func fetchArticleFull(with parentID: String, completion: @escaping (Result<[ArticleInside]>) -> Void) {
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
                let result = try snap.documentsToList(ArticleInside.self)
                completion(Result.success(result))
            } catch {
                completion(Result.failure(.otherError(error)))
            }
        }
    }
}
