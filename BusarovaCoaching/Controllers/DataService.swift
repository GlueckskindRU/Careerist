//
//  DataService.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 22/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class DataService {
    private var isOffline: Bool = (UIApplication.shared.delegate as! AppDelegate).appManager.isOffline
    private let coreDataManager: CoreDataManager
    private let firebaseController: FirebaseController
    
    private let emptyChangeClosure: () -> Void = { }
    
    init() {
        coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
        firebaseController = FirebaseController.shared
    }
    
    /// Fetches array of charachteristics depending of their level.
    ///
    /// - Parameter level: desribes the level of a Characteristic.
    /// - Parameter completion: completion closure: (Result<[Codable]>) -> Void.
    func fetchCharacteristics(of level: CharacteristicsLevel, completion: @escaping (Result<[CharacteristicsModel]>) -> Void) {
        if isOffline {
            completion(Result.success(getOfflineCharacteristics(of: level)))
        } else {
            firebaseController.getDataController().fetchCharacteristics(of: level) {
                (result: Result<[CharacteristicsModel]>) in
                
                switch result {
                case .success(let characteristic):
                    for element in characteristic {
                        self.saveCharacteristic(element)
                    }
                    
                    completion(Result.success(characteristic))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    /// Fetches array of childern characteristics depending on their parentID.
    ///
    /// - Parameter parentID: parents identifier of a requested characteristics
    /// - Parameter completion: completion closure: (Result<[Codable]>) -> Void
    func fetchChildernCharacteristicsOf(_ parentID: String, completion: @escaping (Result<[CharacteristicsModel]>) -> Void) {
        if isOffline {
            completion(Result.success(getOfflineCharacteristics(under: parentID)))
        } else {
            firebaseController.getDataController().fetchChildernCharacteristicsOf(parentID) {
                (result: Result<[CharacteristicsModel]>) in
                
                switch result {
                case .success(let characteristics):
                    for element in characteristics {
                        self.saveCharacteristic(element)
                    }
                    
                    completion(Result.success(characteristics))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    /// Fetches articles according to passed parameters: parentID and parentType
    ///
    /// - Parameter from: value of a DBTables enum, represents the firebase collection
    /// - Parameter by: parents identifier
    /// - Parameter completion: completion closure: (Result<[Codable]>) -> Void
    func fetchArticles(from type: DBTables, by parentID: String, completion: @escaping (Result<[Article]>) -> Void) {
        if isOffline {
            completion(Result.success(getOffileArticles(from: type.rawValue, by: parentID)))
        } else {
            firebaseController.getDataController().fetchArticles(from: type, by: parentID) {
                (result: Result<[Article]>) in

                switch result {
                case .success(let articles):
                    for article in articles {
                        self.saveArticle(article)
                    }

                    completion(Result.success(articles))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    /// Fetches ArticleInside according to passed parentID.
    ///
    /// - Parameter with: parents identifier
    /// - Parameter forPreview: if is **true** all test questions will be skiped. If is **false** all related articleInside elements will be fetched
    /// - Parameter completion: completion closure: Result<[UIArticleInside]>) -> Void
    func fetchArticle(with parentID: String, forPreview: Bool, completion: @escaping (Result<[UIArticleInside]>) -> Void) {
        if isOffline {
            completion(Result.success(self.getOfflineArticleInsideForPreview(by: parentID, forPreview: forPreview)))
        } else {
            firebaseController.getDataController().fetchArticle(with: parentID, forPreview: forPreview) {
                (result: Result<[ArticleInside]>) in

                switch result {
                case .success(let data):
                    self.saveArticleInsideWithTransformationIntoUI(data, completion: completion)
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    /// Method for deleting an article
    ///
    /// - Parameter with: identifier of a deleted article
    /// - Parameter completion: completion closure: (Result < Bool > ) -> Void
    func deleteArticle(with identifier: String, completion: @escaping (Result<Bool>) -> Void) {
        if isOffline {
            completion(Result.failure(AppError.noReachability("Удаление элемента")))
        } else {
            firebaseController.getDataController().deleteData(with: identifier, from: DBTables.articles) {
                (result: Result<Bool>) in
                
                switch result {
                case .success(let isSuccess):
                    self.deleteArticleElement(with: identifier)
                    completion(Result.success(isSuccess))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    /// Method for deleting an articles inside element
    ///
    /// - Parameter with: identifier of a deleted articles inside element
    /// - Parameter completion: completion closure: (Result < Bool > ) -> Void
    func deleteArticleInside(with identifier: String, completion: @escaping (Result<Bool>) -> Void) {
        if isOffline {
            completion(Result.failure(AppError.noReachability("Удаление элемента")))
        } else {
            firebaseController.getDataController().deleteData(with: identifier, from: DBTables.articlesInside) {
                (result: Result<Bool>) in
                
                switch result {
                case .success(let isSuccess):
                    self.deleteArticleInsideElement(with: identifier)
                    completion(Result.success(isSuccess))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    /// Method to save an article.
    ///
    /// - Parameter element: an element of an Article type to save
    /// - Parameter identifier: identifier of a saved element. If is unknown (new article) = nil
    /// - Parameter completion: completion closure: (Result < Article > ) -> Void
    func saveArticle(_ element: Article, with identifier: String?, completion: @escaping (Result<Article>) -> Void) {
        if isOffline {
            completion(Result.failure(AppError.noReachability("Сохранение статьи")))
        } else {
            firebaseController.getDataController().saveData(element, with: identifier, in: DBTables.articles) {
                (result: Result<Article>) in
                
                switch result {
                case .success(let savedElement):
                    self.saveArticle(savedElement)
                    completion(Result.success(savedElement))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    /// Method to save an articles inside element.
    ///
    /// - Parameter element: an element of an UIArticleInside type to save
    /// - Parameter identifier: identifier of a saved element. If is unknown (new article) = nil
    /// - Parameter completion: completion closure: (Result < UIArticleInside > ) -> Void
    func saveArticleInside(_ element: UIArticleInside, with identifier: String?, completion: @escaping (Result<UIArticleInside>) -> Void) {
        if isOffline {
            completion(Result.failure(AppError.noReachability("Сохранение элемента статьи")))
        } else {
            let articleInside = transformIntoArticleInside(element)
            
            firebaseController.getDataController().saveData(articleInside, with: identifier, in: DBTables.articlesInside) {
                (result: Result<ArticleInside>) in
                
                switch result {
                case .success(_):
                    self.saveArticleInside(element)
                    self.saveListElements(element)
                    completion(Result.success(element))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    func uploadImage(_ image: UIImage, with name: String, to address: StoragePath, completion: @escaping (Result<String>) -> Void) {
        if isOffline {
            completion(Result.failure(AppError.noReachability("Загрузка изображения на сервер")))
        } else {
            firebaseController.getStorageController().uploadImage(image, with: name, to: address) {
                (result: Result<String>) in
                
                switch result {
                case .success(let imageURL):
                    completion(Result.success(imageURL))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    func getImageUrl(for gsURL: String, completion: @escaping (Result<URL>) -> Void) {
        if isOffline {
            completion(Result.failure(AppError.noReachability("Получение ссылки на изображение")))
        } else {
            firebaseController.getStorageController().getDownloadURL(for: gsURL) {
                (result: Result<URL>) in
                
                switch result {
                case .success(let url):
                    completion(Result.success(url))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
}

extension DataService {
    // MARK: - private methods for ArticleInside
    private func transformIntoArticleInside(_ element: UIArticleInside) -> ArticleInside {
        switch element.type {
        case .image:
            return ArticleInside(id: element.id,
                                 parentID: element.parentID,
                                 sequence: element.sequence,
                                 type: element.type,
                                 caption: element.caption,
                                 text: nil,
                                 imageURL: element.imageURL,
                                 imageStorageURL: element.imageStorageURL,
                                 imageName: element.imageName,
                                 numericList: nil,
                                 listElements: nil
                                )
        case .list:
            return ArticleInside(id: element.id,
                                 parentID: element.parentID,
                                 sequence: element.sequence,
                                 type: element.type,
                                 caption: element.caption,
                                 text: nil,
                                 imageURL: nil,
                                 imageStorageURL: nil,
                                 imageName: nil,
                                 numericList: element.numeringList,
                                 listElements: element.listElements
                                )
        case .testQuestion:
            return ArticleInside(id: element.id,
                                 parentID: element.parentID,
                                 sequence: element.sequence,
                                 type: element.type,
                                 caption: element.caption,
                                 text: element.text,
                                 imageURL: nil,
                                 imageStorageURL: nil,
                                 imageName: nil,
                                 numericList: nil,
                                 listElements: element.listElements
                                )
        case .text:
            return ArticleInside(id: element.id,
                                 parentID: element.parentID,
                                 sequence: element.sequence,
                                 type: element.type,
                                 caption: element.caption,
                                 text: element.text,
                                 imageURL: nil,
                                 imageStorageURL: nil,
                                 imageName: nil,
                                 numericList: nil,
                                 listElements: nil
                                )
        }
    }
    
    private func deleteArticleInsideElement(with identifier: String) {
        coreDataManager.persistentContainer.performBackgroundTask {
            [weak self] context in
            
            if let element: CDArticleInside = self?.coreDataManager.getEntity(with: identifier, in: context) {
                
                if let _ = element.id {
                    self?.coreDataManager.delete(element, in: context, withSaving: true)
                }
            }
        }
    }
    
    private func saveArticleInside(_ element: UIArticleInside) {
//        print("Внутри saveArticleInside. Начало")
        coreDataManager.persistentContainer.performBackgroundTask {
            [weak self] context in

            if let articleInsideToSave: CDArticleInside = self?.coreDataManager.getEntity(with: element.id, in: context) {
                
                articleInsideToSave.id = element.id
                articleInsideToSave.parentID = element.parentID
                articleInsideToSave.type = Int16(element.type.rawValue)
                articleInsideToSave.sequence = Int16(element.sequence)
                articleInsideToSave.caption = element.caption
                articleInsideToSave.image = element.image
                articleInsideToSave.imageURL = element.imageURL?.absoluteString
                articleInsideToSave.imageStorageURL = element.imageStorageURL
                articleInsideToSave.imageName = element.imageName
                articleInsideToSave.numericList = element.numeringList ?? false
                articleInsideToSave.text = element.text

                self?.coreDataManager.save(context: context)
//                print("Внутри saveArticleInside. Успешо сохранили элемент")
            }
        }
//        print("Внутри saveArticleInside. Конец")
    }
    
    private func saveListElements(_ articleInside: UIArticleInside) {
        guard let listElements = articleInside.listElements else {
                return
        }
        
        let predicate = NSPredicate(format: "parentID == '\(articleInside.id)'")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
        
        coreDataManager.persistentContainer.performBackgroundTask {
            [weak self] context in
            
            if let existingListElements = self?.coreDataManager.fetchData(in: context, for: CDArticleInsideLists.self, predicate: compoundPredicate, sortDescriptor: nil) {
                if !existingListElements.isEmpty {
                    for element in existingListElements {
                        self?.coreDataManager.delete(element, in: context, withSaving: false)
                    }
                }

                for index in listElements.indices {
                    if let elementToSave = self?.coreDataManager.createObject(from: CDArticleInsideLists.self, into: context) {
                        elementToSave.element = listElements[index]
                        elementToSave.parentID = articleInside.id
                        elementToSave.sequence = Int16(index)
                        
                        self?.coreDataManager.save(context: context)
                    }
                }
            }
        }
    }
    
    private func saveNewListElement(_ element: String, with id: String, as sequence: Int) {
        coreDataManager.persistentContainer.performBackgroundTask {
            [weak self] context in
            
            if let elementToSave = self?.coreDataManager.createObject(from: CDArticleInsideLists.self, into: context) {
                
                elementToSave.element = element
                elementToSave.parentID = id
                elementToSave.sequence = Int16(sequence)
                
                self?.coreDataManager.save(context: context)
            }
        }
    }
    
    private func getAsyncOperationForTransformationArticleInside(_ articleInside: ArticleInside, successHandler: @escaping (UIArticleInside) -> Void, errorHandler: @escaping (AppError) -> Void) -> AsyncOperation {
        let operation = TransformArticleInsideOperation(articleInside: articleInside)
        operation.successHandler = successHandler
        operation.errorHandler = errorHandler
        
        return operation
    }
    
    private func transformArticlesInsideForUIViaOperation(_ articlesInside: [ArticleInside]) throws -> [UIArticleInside] {
        do {
            let operationQueue = OperationQueue()
            
            var resultArray = [UIArticleInside]()
            var operations = [AsyncOperation]()
            var detectedError: AppError? = nil
            let errorQueue = DispatchQueue(label: "Karierist.DataService.transformIntoCoreDataArticlesInside.errorQueue", qos: Thread.current.qualityOfService.toDispatchQoS())
            
//            print("Имеем на входе массив из \(articlesInside.count) элементов")
            for articleInsideElement in articlesInside {
                let errorHandler: (AppError) -> Void = {
                    (error) in
                    
                    errorQueue.sync(flags: .barrier, execute: {
                        if detectedError == nil {
                            detectedError = error
                        }
                    })
                    operationQueue.cancelAllOperations()
                }
                
                let successHandler: (UIArticleInside) -> Void = {
                    (uiArticleInside) in
                    
                    self.saveArticleInside(uiArticleInside)
                    self.saveListElements(uiArticleInside)
//                    print("Успешно обработали элемент с id = \(uiArticleInside.id)")
                    resultArray.append(uiArticleInside)
                }
                
                let newOperation = getAsyncOperationForTransformationArticleInside(articleInsideElement, successHandler: successHandler, errorHandler: errorHandler)
                operations.append(newOperation)
            }
            operationQueue.addOperations(operations, waitUntilFinished: true)
            
            if let detectedError = detectedError {
                throw detectedError
            }
//            print("На выходе получили массив из \(resultArray.count) элементов")
            return resultArray.sorted(by: { $0.sequence < $1.sequence })
        } catch {
            throw error
        }
    }
    
    private func saveArticleInsideWithTransformationIntoUI(_ articlesInside: [ArticleInside], completion: @escaping (Result<[UIArticleInside]>) -> Void) {
        do {
            try DispatchQueue.main.async(completion, with: Result.success(self.transformArticlesInsideForUIViaOperation(articlesInside)))
        } catch {
            DispatchQueue.main.async(completion, with: Result.failure(AppError.otherError(error)))
        }
    }
    
    private func getOfflineListElements(by parentID: String) -> [String] {
        let predicate = NSPredicate(format: "parentID == '\(parentID)'")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
        let sortOrder = NSSortDescriptor(key: "sequence", ascending: true)
        
        let coreDataResult = coreDataManager.fetchData(for: CDArticleInsideLists.self, predicate: compoundPredicate, sortDescriptor: sortOrder)
        
        return coreDataResult.compactMap { $0.element }
    }
    
    private func getOfflineArticleInsideForPreview(by parentID: String, forPreview: Bool) -> [UIArticleInside] {
        let parentIDPredicate = NSPredicate(format: "parentID == '\(parentID)'")
        let compoundPredicate: NSCompoundPredicate
        
        if forPreview {
            let typePredicate = NSPredicate(format: "type < \(Int16(ArticleInsideType.testQuestion.rawValue))")
            compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [parentIDPredicate, typePredicate])
        } else {
            compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [parentIDPredicate])
        }
        
        let sortOrder = NSSortDescriptor(key: "sequence", ascending: true)
        
        let coreDataResult = coreDataManager.fetchData(for: CDArticleInside.self, predicate: compoundPredicate, sortDescriptor: sortOrder)
        
        var result = [UIArticleInside]()
        
        for element in coreDataResult {
            if let uiElement = transformIntoUIArticleInside(element) {
                result.append(uiElement)
            }
        }
        
        return result
    }
    
    private func transformIntoUIArticleInside(_ element: CDArticleInside) -> UIArticleInside? {
        guard
            let id = element.id,
            let parentID = element.parentID,
            let type = ArticleInsideType(rawValue: Int(element.type)) else {
                return nil
        }
        
        switch type {
        case .image:
            guard
                let imageURLString = element.imageURL,
                let imageURL = URL(string: imageURLString) else {
                    return nil
            }
            
            return UIArticleInside(id: id,
                                   parentID: parentID,
                                   sequence: Int(element.sequence),
                                   type: type,
                                   caption: element.caption,
                                   text: nil,
                                   image: element.image as? UIImage,
                                   imageURL: imageURL,
                                   imageStorageURL: element.imageStorageURL,
                                   imageName: element.imageName,
                                   numericList: nil,
                                   listElements: nil
                                    )
        case .list:
            let listElements = getOfflineListElements(by: id)
            
            return UIArticleInside(id: id,
                                   parentID: parentID,
                                   sequence: Int(element.sequence),
                                   type: type,
                                   caption: element.caption,
                                   text: nil,
                                   image: nil,
                                   imageURL: nil,
                                   imageStorageURL: nil,
                                   imageName: nil,
                                   numericList: element.numericList,
                                   listElements: listElements
            )

        case .testQuestion:
            let listElements = getOfflineListElements(by: id)
            
            return UIArticleInside(id: id,
                                   parentID: parentID,
                                   sequence: Int(element.sequence),
                                   type: type,
                                   caption: element.caption,
                                   text: element.text,
                                   image: nil,
                                   imageURL: nil,
                                   imageStorageURL: nil,
                                   imageName: nil,
                                   numericList: nil,
                                   listElements: listElements
            )

        case .text:
            return UIArticleInside(id: id,
                                   parentID: parentID,
                                   sequence: Int(element.sequence),
                                   type: type,
                                   caption: element.caption,
                                   text: element.text,
                                   image: nil,
                                   imageURL: nil,
                                   imageStorageURL: nil,
                                   imageName: nil,
                                   numericList: nil,
                                   listElements: nil
            )
        }
    }
}

extension DataService {
    // MARK: - private methods for Article
    private func deleteArticleElement(with identifier: String) {
        let element: CDArticle = coreDataManager.getEntity(with: identifier)
        if let _ = element.id {
            coreDataManager.delete(element)
        }
    }
    
    private func saveArticle(_ article: Article) {
        coreDataManager.persistentContainer.performBackgroundTask {
            [weak self] context in
            
            if let articleToSave: CDArticle = self?.coreDataManager.getEntity(with: article.id, in: context) {
                
                articleToSave.id = article.id
                articleToSave.parentID = article.parentID
                articleToSave.parentType = article.parentType
                articleToSave.sequence = Int16(article.sequence)
                articleToSave.title = article.title
                articleToSave.type = Int16(article.type.rawValue)
                
                self?.coreDataManager.save(context: context)
            }
        }
    }
    
    private func getOffileArticles(from type: String, by parentID: String) -> [Article] {
        let typePredicate = NSPredicate(format: "parentType == '\(type)'")
        let parentIDPredicate = NSPredicate(format: "parentID == '\(parentID)'")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, parentIDPredicate])
        
        let sortOrder = NSSortDescriptor(key: "sequence", ascending: true)
        
        let resultArray = coreDataManager.fetchData(for: CDArticle.self, predicate: compoundPredicate, sortDescriptor: sortOrder)
        
        return resultArray.compactMap { transformIntoArticle($0) }
    }
    
    private func transformIntoArticle(_ model: CDArticle) -> Article? {
        guard
            let id = model.id,
            let parentID = model.parentID,
            let parentType = model.parentType,
            let title = model.title,
            let type = ArticleType(rawValue: Int(model.type)) else {
                return nil
        }
        
        return Article(id: id,
                       title: title,
                       parentID: parentID,
                       parentType: parentType,
                       sequence: Int(model.sequence),
                       grants: 0,
                       authorID: "",
                       rating: 0,
                       verified: true,
                       type: type
                        )
    }
}

extension DataService {
    // MARK: - private methods for ChractericsModel
    private func saveCharacteristic(_ element: CharacteristicsModel) {
        coreDataManager.persistentContainer.performBackgroundTask {
            [weak self] context in
            
            if let elementToSave: CDCharacteristic = self?.coreDataManager.getEntity(with: element.id, in: context) {
                
                elementToSave.id = element.id
                elementToSave.name = element.name
                elementToSave.parentID = element.parentID
                elementToSave.collapsed = element.collapsed
                elementToSave.level = Int16(element.level.rawValue)
                
                self?.coreDataManager.save(context: context)
            }
        }
    }
    
    private func getOfflineCharacteristics(of level: CharacteristicsLevel) -> [CharacteristicsModel]{
        let predicate = NSPredicate(format: "level == \(level.rawValue)")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
        let sortOrder = NSSortDescriptor(key: "name", ascending: true)
        
        let resultArray = coreDataManager.fetchData(for: CDCharacteristic.self, predicate: compoundPredicate, sortDescriptor: sortOrder)
        
        return resultArray.compactMap { transformIntoCharacteristicsModel($0) }
    }
    
    private func getOfflineCharacteristics(under parentID: String) -> [CharacteristicsModel]{
        let predicate = NSPredicate(format: "parentID == '\(parentID)'")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
        let sortOrder = NSSortDescriptor(key: "name", ascending: true)
        
        let resultArray = coreDataManager.fetchData(for: CDCharacteristic.self, predicate: compoundPredicate, sortDescriptor: sortOrder)
        
        return resultArray.compactMap { transformIntoCharacteristicsModel($0) }
    }
    
    private func transformIntoCharacteristicsModel(_ model: CDCharacteristic) -> CharacteristicsModel? {
        guard
            let id = model.id,
            let name = model.name,
            let parentID = model.parentID,
            let level = CharacteristicsLevel(rawValue: Int(model.level)) else {
                return nil
        }
        
        return CharacteristicsModel(id: id,
                                    name: name,
                                    parentID: parentID,
                                    level: level
                                    )
    }
}
