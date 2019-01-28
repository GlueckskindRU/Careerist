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

    let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    var receivedArticlePushes: [CDReceivedArticles] = []
    var receivedAdvicesPushes: [CDReceivedAdvices] = []
    
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
        
        let reloadingCompletion: () -> Void = {
            self.tableView.reloadData()
            self.tableView.tableFooterView = TableFooterView.shared.create(with: footerText, in: self.view, empty: self.listOfReceivedAssets.isEmpty)
            self.activityIndicator.stop()
        }
        
        guard
            let currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser(),
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
                fetchAsset(with: String(describing: subscribedReceivedArticlesIDsPushes[i]), as: type, having: i, for: currentUser, completion: reloadingCompletion)
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
                fetchAsset(with: String(describing: subscribedReceivedAdvicesIDsPushes[i]), as: type, having: i, for: currentUser, completion: reloadingCompletion)
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
                                   type: type
                                    )
        
        let dummyValue = ReceivedAsset(dummyArticle, false, false, false)
        
        listOfReceivedAssets = Array(repeating: dummyValue, count: length)
    }
    
    private func fetchAsset(with id: String, as type: ArticleType, having position: Int, for currentUser: User, completion: @escaping () -> Void) {
        FirebaseController.shared.getDataController().fetchData(with: id, from: DBTables.articles) {
            (assetResult: Result<Article>) in
            
            switch assetResult {
            case .success(let asset):
                switch type {
                case .advice:
                    self.listOfReceivedAssets[position] = ReceivedAsset(asset, self.getAdvicePushReadingStatus(for: asset.id), false, false)
                    return completion()
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
                                let ratings = currentUser.rating
                                
                                for rating in ratings {
                                    for questionDetail in rating.details {
                                        if questionSet.contains(questionDetail.questionID) {
                                            if !questionDetail.passed {
                                                passed = false
                                            }
                                            break
                                        }
                                    }
                                }
                            }
                            
                            self.listOfReceivedAssets[position] = ReceivedAsset(asset, self.getArticlePushReadingStatus(for: asset.id), self.getArticlePushQuestionsStatus(for: asset.id), passed)
                            return completion()
                        case .failure(let error):
                            return self.showAlert(with: error)
                        }
                    }
                }
            case .failure(let error):
                return self.showAlert(with: error)
            }
        }
    }
}
