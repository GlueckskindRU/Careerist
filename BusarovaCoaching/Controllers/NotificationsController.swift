    //
//  NotificationsController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/12/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class NotificationsController {
    typealias EmptyVoid = () -> Void
    private let coreDataManager: CoreDataManager
    private let currentUser: User
    private let queue: DispatchQueue
    
    private let activityIndicator = ActivityIndicator()
    private let dispatchGroup = DispatchGroup()
    
    init(coreDataManager: CoreDataManager, currentUser: User, queue: DispatchQueue) {
        self.coreDataManager = coreDataManager
        self.currentUser = currentUser
        self.queue = queue
    }
    
    func fetchAllWaitingPushes(completion: @escaping EmptyVoid) {
        FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.articlesSchedule) {
            (scheduleResult: Result<SubscriptionArticleSchedule>) in

            var withQuestion: Bool = false
            if let schedule = scheduleResult.value {
                withQuestion = schedule.withQuestions
            }
            self.fetchArticlePushes(questionsAreIncluded: withQuestion)
            self.fetchAdvicePushes()

            self.dispatchGroup.notify(queue: self.queue) {
                completion()
            }
        }
    }
    
    private func fetchArticlePushes(questionsAreIncluded: Bool) {
        dispatchGroup.enter()
        FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.waitingArticlePushes) {
            (articlesPushingResult: Result<WaitingArticlePushes>) in

            if let articlesPush = articlesPushingResult.value {
                let pushedArticleIDs = articlesPush.articles.map { $0 }
                
                guard !pushedArticleIDs.isEmpty else {
                    self.dispatchGroup.leave()
                    return
                }
                
                let storedPushesIDs = self.fetchStoredArticleIDs()

                for articleID in pushedArticleIDs {
                    if !storedPushesIDs.contains(articleID) {
                        self.dispatchGroup.enter()
                        self.fetchAndSaveArticle(with: articleID, questionsAreIncluded: questionsAreIncluded)
                    }
                }

                self.dispatchGroup.leave()
            } else {
                print("Fetching an entity from the waitingArticlePushes table returned an error: \(String(describing: articlesPushingResult.error))")
                self.dispatchGroup.leave()
            }
        }
    }
    
    private func fetchStoredArticleIDs() -> Set<String> {
        let storedData = coreDataManager.fetchData(for: CDReceivedArticles.self)
        
        var result: Set<String> = []
        
        for element in storedData {
            if let id = element.id {
                result.insert(id)
            }
        }

        return result
    }
    
    private func fetchAndSaveArticle(with id: String, questionsAreIncluded: Bool) {
        FirebaseController.shared.getDataController().fetchData(with: id, from: DBTables.articles) {
            (articleResult: Result<Article>) in

            if let article = articleResult.value {
                FirebaseController.shared.getDataController().fetchArticle(with: id, forPreview: false) {
                    (articleInsideResult: Result<[ArticleInside]>) in

                    let hasQuestions: Bool
                    
                    if questionsAreIncluded {
                        switch articleInsideResult {
                        case .success(let articleInsideArray):
                            let questions = articleInsideArray.filter { $0.type == ArticleInsideType.testQuestion }
                            hasQuestions = !questions.isEmpty
                        case .failure(_):
                            hasQuestions = false
                        }
                    } else {
                        hasQuestions = false
                    }
                    
                    self.saveReceivedArticlePushInCoreData(article, hasQuestions: hasQuestions)
                }
            } else {
                print("Fetching an entity with id <\(id)> from the article (for article type) table returned an error: \(String(describing: articleResult.error))")
            }
        }
    }
    
    private func saveReceivedArticlePushInCoreData(_ article: Article, hasQuestions: Bool) {
        let context = coreDataManager.getContext()
        let newReceivedArticlePush: CDReceivedArticles = coreDataManager.getEntity(with: article.id, in: context)
        
        newReceivedArticlePush.id = article.id
        newReceivedArticlePush.parentID = article.parentID
        newReceivedArticlePush.wasRead = false
        newReceivedArticlePush.hasQuestions = hasQuestions
        newReceivedArticlePush.receivedTime = Date()
        
        coreDataManager.save(context: context)
        
        dispatchGroup.leave()
    }
    
    private func fetchAdvicePushes() {
        dispatchGroup.enter()
        FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.waitingAdvicePushes) {
            (advicesPushingResult: Result<WaitingAdvicePushes>) in
            
            if let advicesPush = advicesPushingResult.value {
                let pushedAdviceIDs = advicesPush.advices.map { $0 }
                
                guard !pushedAdviceIDs.isEmpty else {
                    self.dispatchGroup.leave()
                    return
                }
                
                let storedPushesIDs = self.fetchStoredAdviceIDs()
                
                for adviceID in pushedAdviceIDs {
                    if !storedPushesIDs.contains(adviceID) {
                        self.dispatchGroup.enter()
                        self.fetchAndSaveAdvice(with: adviceID)
                    }
                }
                
                self.dispatchGroup.leave()
            } else {
                print("Fetching an entity from the waitingAdvicePushes table returned an error: \(String(describing: advicesPushingResult.error))")
                self.dispatchGroup.leave()
            }
        }
    }
    
    private func fetchStoredAdviceIDs() -> Set<String> {
        let storedData = coreDataManager.fetchData(for: CDReceivedAdvices.self)
        
        var result: Set<String> = []
        
        for element in storedData {
            if let id = element.id {
                result.insert(id)
            }
        }
        
        return result
    }
    
    private func fetchAndSaveAdvice(with id: String) {
        FirebaseController.shared.getDataController().fetchData(with: id, from: DBTables.articles) {
            (adviceResult: Result<Article>) in
            
            if let advice = adviceResult.value {
                self.saveReceivedAdvicePushInCoreData(advice)
            } else {
                print("Fetching an entity with id <\(id)> from the article (for advice type) table returned an error: \(String(describing: adviceResult.error))")
            }
        }
    }
    
    private func saveReceivedAdvicePushInCoreData(_ advice: Article) {
        let context = coreDataManager.getContext()
        let newReceivedAdvicePush: CDReceivedAdvices = coreDataManager.getEntity(with: advice.id, in: context)
        
        newReceivedAdvicePush.id = advice.id
        newReceivedAdvicePush.parentID = advice.parentID
        newReceivedAdvicePush.wasRead = false
        newReceivedAdvicePush.receivedTime = Date()
        
        coreDataManager.save(context: context)
        
        dispatchGroup.leave()
    }
}
