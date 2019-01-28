    //
//  NotificationsController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/12/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class NotificationsController {
    private let coreDataManager: CoreDataManager
    private let currentUser: User?
    private let activityIndicator = ActivityIndicator()
    
    init() {
        self.coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
        self.currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser()
    }
    
    func processWithReceivedUserInfo(updateType: String, informationType: String) {
        guard let currentUser = currentUser else {
            return
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.start()
        }
        if updateType == "SUBSCRIPTION" {
            switch informationType {
            case SubscriptionInformationType.articles.rawValue:
                print("We receive articles subscription")
                getUsersSettings(for: currentUser)
            case SubscriptionInformationType.advices.rawValue:
                print("We receive ADVICES subscription")
                fetchWaitingAdvicePushes(for: currentUser)
            default:
                DispatchQueue.main.async {
                    self.activityIndicator.stop()
                }
                return
            }
        }
    }
    
    private func getUsersSettings(for currentUser: User) {
        FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.articlesSchedule) {
            (result: Result<SubscriptionArticleSchedule>) in
            
            if result.isSuccess, let schedule = result.value {
                self.fetchWaitingArticlePushes(for: currentUser, questionsAreIncluded: schedule.withQuestions)
            }
        }
    }
    
    private func fetchWaitingArticlePushes(for currentUser: User, questionsAreIncluded: Bool) {
        FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.waitingArticlePushes) {
            (waitingPushResult: Result<WaitingArticlePushes>) in
            
            if waitingPushResult.isSuccess, let waitingArticlePush = waitingPushResult.value {
                FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.sentArticlePushes) {
                    (sentPushResult: Result<SentArticlePushes>) in
                    
                    var actualSentPushes: SentArticlePushes
                    
                    switch sentPushResult {
                    case .success(let existingSentPush):
                        actualSentPushes = existingSentPush
                    case .failure(_):
                        actualSentPushes = SentArticlePushes(id: currentUser.id)
                    }
                    
                    for articleID in waitingArticlePush.articles {
                        FirebaseController.shared.getDataController().fetchData(with: articleID, from: DBTables.articles) {
                            (articleResult: Result<Article>) in
                            
                            if articleResult.isSuccess, let article = articleResult.value {
                                FirebaseController.shared.getDataController().fetchArticle(with: articleID, forPreview: false) {
                                    (articlesInsideResult: Result<[ArticleInside]>) in
                                    
                                    let hasQuestions: Bool
                                    
                                    if questionsAreIncluded {
                                        switch articlesInsideResult {
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
                                    actualSentPushes.articles.insert(articleID)
                                    
                                    FirebaseController.shared.getDataController().saveData(actualSentPushes, with: currentUser.id, in: DBTables.sentArticlePushes) {
                                        (result: Result<SentArticlePushes>) in
                                        
                                        // do nothing here
                                    }
                                }
                            }
                        }
                    }
                    
                    let emptyWaitingArticlePush = WaitingArticlePushes(id: currentUser.id)
                    FirebaseController.shared.getDataController().saveData(emptyWaitingArticlePush, with: currentUser.id, in: DBTables.waitingArticlePushes) {
                        (result: Result<WaitingArticlePushes>) in
                        
                        // do nothing here
                    }
                }
            } else {
                print("Fetching an entity from the waitingArticlePushes table returned an error: \(String(describing: waitingPushResult.error))")
            }
            
            DispatchQueue.main.async {
                self.activityIndicator.stop()
            }
        }
    }
    
    private func fetchWaitingAdvicePushes(for currentUser: User) {
        FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.waitingAdvicePushes) {
            (waitingPushResult: Result<WaitingAdvicePushes>) in
            print("waitingPushResult = <\(waitingPushResult)>")
            if waitingPushResult.isSuccess, let waitingAdvicePush = waitingPushResult.value {
                FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.sentAdvicePushes) {
                    (sentPushResult: Result<SentAdvicePushes>) in
                    print("sentPushResult = <\(sentPushResult)>")
                    var actualSentPushes: SentAdvicePushes
                    
                    switch sentPushResult {
                    case .success(let existingSentPush):
                        actualSentPushes = existingSentPush
                    case .failure(_):
                        actualSentPushes = SentAdvicePushes(id: currentUser.id)
                    }
                    
                    for adviceID in waitingAdvicePush.advices {
                        FirebaseController.shared.getDataController().fetchData(with: adviceID, from: DBTables.articles) {
                            (adviceResult: Result<Article>) in
                            print("adviceResult = <\(adviceResult)>")
                            if adviceResult.isSuccess, let advice = adviceResult.value {
                                self.saveReceivedAdvicePushInCoreData(advice)
                                actualSentPushes.advices.insert(adviceID)
                            }
                            
                            FirebaseController.shared.getDataController().saveData(actualSentPushes, with: currentUser.id, in: DBTables.sentAdvicePushes) {
                                (result: Result<SentAdvicePushes>) in
                                
                                // do nothing here
                            }
                        }
                    }
                    
                    let emptyWaitingAdvicePush = WaitingAdvicePushes(id: currentUser.id)
                    FirebaseController.shared.getDataController().saveData(emptyWaitingAdvicePush, with: currentUser.id, in: DBTables.waitingAdvicePushes) {
                        (result: Result<WaitingAdvicePushes>) in
                        
                        // do nothing here
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.activityIndicator.stop()
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
    }
    
    private func saveReceivedAdvicePushInCoreData(_ advice: Article) {
        let context = coreDataManager.getContext()
        let newReceivedAdvicePush: CDReceivedAdvices = coreDataManager.getEntity(with: advice.id, in: context)
        
        newReceivedAdvicePush.id = advice.id
        newReceivedAdvicePush.parentID = advice.parentID
        newReceivedAdvicePush.wasRead = false
        newReceivedAdvicePush.receivedTime = Date()
        
        coreDataManager.save(context: context)
    }
}
