//
//  ListOfReceivedArticlesAndAdvices.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/12/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

typealias ReceivedAsset = (asset: Article, wasRead: Bool, hasQuestions: Bool, passed: Bool)

class ListOfReceivedArticlesAndAdvices: UITableViewController {
    private var competence: CharacteristicsModel?
    private var listOfReceivedAssets: [ReceivedAsset] = []
    private var assetType: ArticleType?
    private let activityIndicator = ActivityIndicator()
    private var currentUser: User?

    let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    var receivedArticlePushes: [CDReceivedArticles] = []
    var receivedAdvicesPushes: [CDReceivedAdvices] = []
    
    let dispatchGroup = DispatchGroup()
    let queue = DispatchQueue(label: "ListOfReceivedArticlesAndAdvices.fetchSortedData", qos: .userInitiated)
    var updatedPassedQuestionsDetails: Set<PassedQuestions.Details> = []
    
    func configure(with competence: CharacteristicsModel, as type: ArticleType) {
        self.competence = competence
        self.assetType = type
        
        let sortDescriptor = NSSortDescriptor(key: "receivedTime", ascending: false)
        receivedArticlePushes = coreDataManager.fetchData(for: CDReceivedArticles.self, predicate: nil, sortDescriptor: sortDescriptor)
        receivedAdvicesPushes = coreDataManager.fetchData(for: CDReceivedAdvices.self, predicate: nil, sortDescriptor: sortDescriptor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListOfAdvicesCell.self, forCellReuseIdentifier: CellIdentifiers.listOfAdvicesCell.rawValue)
        tableView.register(ListOfArticlesCell.self, forCellReuseIdentifier: CellIdentifiers.listOfArticlesCell.rawValue)
        
        navigationItem.title = competence?.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser()
        
        refreshUI()
    }
}

// MARK: - TableView DataSource
extension ListOfReceivedArticlesAndAdvices {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfReceivedAssets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let assetType = assetType else {
            return UITableViewCell()
        }
        
        switch assetType {
        case .advice:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.listOfAdvicesCell.rawValue, for: indexPath) as! ListOfAdvicesCell
            
            cell.configure(with: listOfReceivedAssets[indexPath.row], as: indexPath.row + 1)
            
            return cell
        case .article:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.listOfArticlesCell.rawValue, for: indexPath) as! ListOfArticlesCell
            
            cell.configure(with: listOfReceivedAssets[indexPath.row], as: indexPath.row + 1)
            return cell
        }
    }
}

// MARK: - TableView Delegate
extension ListOfReceivedArticlesAndAdvices {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previewVC = ArticlesPreviewTableViewController()
        previewVC.configure(with: listOfReceivedAssets[indexPath.row].asset, hasQuestions: listOfReceivedAssets[indexPath.row].hasQuestions)
            
        listOfReceivedAssets[indexPath.row].wasRead = true
        saveReadingMark(for: listOfReceivedAssets[indexPath.row].asset.id)
        navigationController?.pushViewController(previewVC, animated: true)
    }
}

extension ListOfReceivedArticlesAndAdvices {
    private func refreshUI() {
        guard
            let competence = competence,
            let assetType = assetType else {
            return
        }
        
        listOfReceivedAssets = []
        fetchSortedData(for: competence, as: assetType)
    }
    
    private func saveReadingMark(for id: String) {
        guard let assetType = assetType else {
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: "receivedTime", ascending: false)
        
        switch assetType {
        case .advice:
            let context = coreDataManager.getContext()
            let adviceToSave: CDReceivedAdvices = coreDataManager.getEntity(with: id, in: context)
            adviceToSave.wasRead = true
            coreDataManager.save(context: context)
            
            receivedAdvicesPushes = coreDataManager.fetchData(for: CDReceivedAdvices.self, predicate: nil, sortDescriptor: sortDescriptor)
        case .article:
            let context = coreDataManager.getContext()
            let articleToSave: CDReceivedArticles = coreDataManager.getEntity(with: id, in: context)
            articleToSave.wasRead = true
            coreDataManager.save(context: context)
            
            receivedArticlePushes = coreDataManager.fetchData(for: CDReceivedArticles.self, predicate: nil, sortDescriptor: sortDescriptor)
        }
        
        tableView.reloadData()
    }
    
    private func showAlert(with error: AppError) {
        self.activityIndicator.stop()
        let alertDialog = AlertDialog(title: nil, message: error.getError())
        alertDialog.showAlert(in: self, completion: nil)
    }
    
    private func getArticlePushReadingStatus(for id: String) -> Bool {
        for push in receivedArticlePushes {
            if let receivedID = push.id {
                if receivedID == id {
                    return push.wasRead
                }
            }
        }
        
        return false
    }
    
    private func getArticlePushQuestionsStatus(for id: String) -> Bool {
        for push in receivedArticlePushes {
            if let receivedID = push.id {
                if receivedID == id {
                    return push.hasQuestions
                }
            }
        }
        
        return false
    }
    
    private func getAdvicePushReadingStatus(for id: String) -> Bool {
        for push in receivedAdvicesPushes {
            if let receivedID = push.id {
                if receivedID == id {
                    return push.wasRead
                }
            }
        }
        
        return false
    }
}

// MARK: - Fetching of a listOfReceivedAssets properly sorted, as assets were received
extension ListOfReceivedArticlesAndAdvices {
    private func fetchSortedData(for competence: CharacteristicsModel, as type: ArticleType) {
        let footerText: String
        switch type {
        case .advice:
            footerText = "Вы ещё не получали ни одного совета дня по выбранной компетенции"
        case .article:
            footerText = "Вы ещё не получали ни одной статьи по выбранной компетенции"
        }
        
        guard
            let currentUser = currentUser,
            let subscribedIndicators = currentUser.subscribedCharacteristics[competence.id] else {
            tableView.reloadData()
            tableView.tableFooterView = TableFooterView.shared.create(with: footerText, in: self.view, empty: self.listOfReceivedAssets.isEmpty)
            return
        }
        
        switch type {
        case .article:
            var subscribedReceivedArticlesIDsPushes: [String] = []
            for articlePush in receivedArticlePushes {
                if let parentID = articlePush.parentID, let articleID = articlePush.id {
                    if subscribedIndicators.contains(parentID) {
                        subscribedReceivedArticlesIDsPushes.append(articleID)
                    }
                }
            }

            createProperLengthForListOfReceivedAssets(with: subscribedReceivedArticlesIDsPushes.count, as: type)
            
            for i in 0..<subscribedReceivedArticlesIDsPushes.count {
                activityIndicator.start()
                dispatchGroup.enter()
                fetchAsset(with: String(describing: subscribedReceivedArticlesIDsPushes[i]), as: type, having: i, for: currentUser, competenceId: competence.id)
            }
            
        case .advice:
            var subscribedReceivedAdvicesIDsPushes: [String] = []
            for advicePush in receivedAdvicesPushes {
                if let parentID = advicePush.parentID, let adviceID = advicePush.id {
                    if subscribedIndicators.contains(parentID) {
                        subscribedReceivedAdvicesIDsPushes.append(adviceID)
                    }
                }
            }
            
            createProperLengthForListOfReceivedAssets(with: subscribedReceivedAdvicesIDsPushes.count, as: type)
            
            for i in 0..<subscribedReceivedAdvicesIDsPushes.count {
                activityIndicator.start()
                dispatchGroup.enter()
                fetchAsset(with: String(describing: subscribedReceivedAdvicesIDsPushes[i]), as: type, having: i, for: currentUser, competenceId: competence.id)
            }
        }
        
        dispatchGroup.notify(queue: self.queue) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.tableFooterView = TableFooterView.shared.create(with: footerText, in: self.view, empty: self.listOfReceivedAssets.isEmpty)
            }
            
            var updatedUser = currentUser
            if let existingRatingForCompetence = currentUser.rating.filter( { $0.competenceID == competence.id } ).first {
                var existingDetails = existingRatingForCompetence.details
                
                if !self.updatedPassedQuestionsDetails.isEmpty {
                    let setOfExistingQuestionIDs = Set(existingDetails.map { $0.questionID } )
                    
                    for questionID in setOfExistingQuestionIDs {
                        if
                            let updatedQuestionDetail = self.updatedPassedQuestionsDetails.filter( { $0.questionID == questionID } ).first,
                            let existingQuestionDetail = existingDetails.filter( { $0.questionID == questionID } ).first {
                            existingDetails.remove(existingQuestionDetail)
                            existingDetails.insert(updatedQuestionDetail)
                            self.updatedPassedQuestionsDetails.remove(updatedQuestionDetail)
                        }
                    }
                }
                
                if !self.updatedPassedQuestionsDetails.isEmpty {
                    for updatedDetail in self.updatedPassedQuestionsDetails {
                        existingDetails.insert(updatedDetail)
                    }
                }
                
                let updatedRatingOfCompetence = PassedQuestions(competenceID: competence.id,
                                                                earnedPoints: existingRatingForCompetence.earnedPoints,
                                                                totalPoints: existingRatingForCompetence.totalPoints,
                                                                details: existingDetails
                                                                )
                updatedUser.rating.remove(existingRatingForCompetence)
                updatedUser.rating.insert(updatedRatingOfCompetence)
            } else {
                let newPassedQuestions = PassedQuestions(competenceID: competence.id,
                                                         earnedPoints: 0,
                                                         totalPoints: competence.totalPoints,
                                                         details: self.updatedPassedQuestionsDetails
                                                        )
                updatedUser.rating.insert(newPassedQuestions)
            }
            
            FirebaseController.shared.getDataController().saveData(updatedUser, with: updatedUser.id, in: DBTables.users) {
                (result: Result<User>) in

                if let user = result.value {
                    (UIApplication.shared.delegate as! AppDelegate).appManager.loggedIn(as: user)
                    self.currentUser = user
                }
                
                DispatchQueue.main.async {
                    self.activityIndicator.stop()
                }
            }
        }
    }
    
    private func createProperLengthForListOfReceivedAssets(with length: Int, as type: ArticleType) {
        let dummyArticle = Article(id: "",
                                   title: "",
                                   parentID: "",
                                   parentType: "",
                                   sequence: 0,
                                   grants: 0,
                                   authorID: "",
                                   rating: 0,
                                   verified: false,
                                   type: type,
                                   competenceID: ""
                                    )
        
        let dummyValue = ReceivedAsset(dummyArticle, false, false, false)
        
        listOfReceivedAssets = Array(repeating: dummyValue, count: length)
    }
    
    private func fetchAsset(with id: String, as type: ArticleType, having position: Int, for currentUser: User, competenceId: String) {
        FirebaseController.shared.getDataController().fetchData(with: id, from: DBTables.articles) {
            (assetResult: Result<Article>) in
            
            switch assetResult {
            case .success(let asset):
                switch type {
                case .advice:
                    self.listOfReceivedAssets[position] = ReceivedAsset(asset, self.getAdvicePushReadingStatus(for: asset.id), false, false)
                    self.dispatchGroup.leave()
                case .article:
                    FirebaseController.shared.getDataController().fetchArticle(with: asset.id, forPreview: false) {
                        (articleInsideResult: Result<[ArticleInside]>) in
                        
                        switch articleInsideResult {
                        case .success(let articlesInsideArray):
                            var passed = true
                            
                            let questionSet = Set(articlesInsideArray.filter { $0.type == ArticleInsideType.testQuestion }.map { $0.id } )
                            
                            if questionSet.isEmpty {
                                passed = false
                            } else {
                                for questionID in questionSet {
                                    let questionPassed = self.hasPassedQuestion(with: questionID, for: competenceId, user: currentUser)
                                    let newQuestionDetail = PassedQuestions.Details(questionID: questionID,
                                                                                    passed: questionPassed,
                                                                                    snoozedTill: nil
                                                                                    )
                                    
                                    self.updatedPassedQuestionsDetails.insert(newQuestionDetail)
                                    
                                    if !questionPassed {
                                        passed = false
                                    }
                                }
                            }
                            
                            self.listOfReceivedAssets[position] = ReceivedAsset(asset, self.getArticlePushReadingStatus(for: asset.id), self.getArticlePushQuestionsStatus(for: asset.id), passed)
                            self.dispatchGroup.leave()
                        case .failure(let error):
                            self.dispatchGroup.leave()
                            return self.showAlert(with: error)
                        }
                    }
                }
            case .failure(let error):
                self.dispatchGroup.leave()
                return self.showAlert(with: error)
            }
        }
    }
    
    private func hasPassedQuestion(with questionID: String, for competenceID: String, user: User) -> Bool {
        var result: Bool
        
        if let ratingForCompetence = user.rating.filter( { $0.competenceID == competenceID } ).first {
            if let questionDetails = ratingForCompetence.details.filter( { $0.questionID == questionID } ).first {
                result = questionDetails.passed
            } else {
                result = false
            }
        } else {
            result = false
        }
        
        return result
    }
}
