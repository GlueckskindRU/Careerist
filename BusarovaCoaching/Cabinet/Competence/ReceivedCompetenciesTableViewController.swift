//
//  ReceivedCompetenciesTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 11/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

typealias CompetenceWithReadingStatus = (competences: CharacteristicsModel, subscribedIndicators: Set<String>, hasNewArticle: Bool, hasNewAdvice: Bool)
typealias IndicatorsDictionary = [String: Set<CharacteristicsModel>]

class ReceivedCompetenciesTableViewController: UITableViewController {
    private var subscribedCompetenceList: [CompetenceWithReadingStatus] = []
    private var coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    
    lazy private var customBackButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Assets.backArrow.rawValue),
                               style: UIBarButtonItem.Style.plain,
                               target: self,
                               action: #selector(customBackButtonTapped(_:))
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.register(ReceivedCompetenciesCell.self, forCellReuseIdentifier: CellIdentifiers.receivedCompetenciesCell.rawValue)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.tableFooterView = UIView()
        
        let headerView = HeaderViewWithInfoText()
        headerView.configure(infoText: "Если компетенция содержит непрочитанную статью или совет, она отмечается восклицательным знаком")
        tableView.setAndLayoutTableHeaderView(header: headerView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = customBackButton
        
        navigationItem.title = "Мои компетенции"
        
        if let tintColor = UIColor(named: "cabinetTintColor") {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: tintColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
            ]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationMultilineTitle()
        
        guard let currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser() else {
            self.refreshUI()
            return
        }

        let queue = DispatchQueue(label: "ReceivedCompetenciesTableViewController.refreshNotificationsQueue", qos: .userInitiated)

        let notificationController = NotificationsController(coreDataManager: coreDataManager, currentUser: currentUser, queue: queue)
        notificationController.fetchAllWaitingPushes {
            DispatchQueue.main.async {
                self.refreshUI()
            }
        }
    }
}

// MARK: - TableView DataSource
extension ReceivedCompetenciesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribedCompetenceList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.receivedCompetenciesCell.rawValue, for: indexPath) as? ReceivedCompetenciesCell else {
            return UITableViewCell()
        }
        
        cell.configure(for: subscribedCompetenceList[indexPath.row])
        
        return cell
    }
}

// MARK: - Refreshing utilities
extension ReceivedCompetenciesTableViewController {
    private func refreshUI() {
        subscribedCompetenceList = []
        
        tableView.reloadData()
        
        guard let currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser() else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        var setOfSubscribedCompetenciesIDs: Set<String> = []
        for (competenceID, _) in currentUser.subscribedCharacteristics {
            setOfSubscribedCompetenciesIDs.insert(competenceID)
        }
        
        FirebaseController.shared.getDataController().fetchCharacteristics(of: CharacteristicsLevel.competences) {
            (allCompetenciesResult: Result<[CharacteristicsModel]>) in
            
            switch allCompetenciesResult {
            case .success(let allCompetencies):
                let subscribedCompetenciesArray = allCompetencies.filter { setOfSubscribedCompetenciesIDs.contains($0.id) }
                
                for competence in subscribedCompetenciesArray {
                    if let subscribedIndicatorIDs = currentUser.subscribedCharacteristics[competence.id] {
                        self.fillCompetenceList(for: competence, indicatorIDs: subscribedIndicatorIDs)
                    }
                }
                
                self.tableView.reloadData()
                activityIndicator.stop()
            case .failure(let error):
                activityIndicator.stop()
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
    
    private func fillCompetenceList(for competence: CharacteristicsModel, indicatorIDs: Set<String>) {
        let newArticlesStatusArray = indicatorIDs.map { hasNewArticle(under: $0) }
        let newArticleStatus = newArticlesStatusArray.contains(true)
        
        let newAdvicesStatusArray = indicatorIDs.map { hasNewAdvice(under: $0) }
        let newAdviceStatus = newAdvicesStatusArray.contains(true)
        
        let newSubscribedCompetence = CompetenceWithReadingStatus(competence, indicatorIDs, newArticleStatus, newAdviceStatus)
        self.subscribedCompetenceList.append(newSubscribedCompetence)
    }
    
    private func hasNewArticle(under indicatorID: String) -> Bool {
        let predicate = NSPredicate(format: "parentID CONTAINS[cd] '\(indicatorID)'")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
        
        let articles = coreDataManager.fetchData(for: CDReceivedArticles.self, predicate: compoundPredicate, sortDescriptor: nil)
        
        for article in articles {
            if !article.wasRead {
                return true
            }
        }
        
        return false
    }
    
    private func hasNewAdvice(under indicatorID: String) -> Bool {
        let predicate = NSPredicate(format: "parentID CONTAINS[cd] '\(indicatorID)'")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
        
        let advices = coreDataManager.fetchData(for: CDReceivedAdvices.self, predicate: compoundPredicate, sortDescriptor: nil)
        
        for advice in advices {
            if !advice.wasRead {
                return true
            }
        }
        
        return false
    }
}

// MARK: - Gesture Tap Recognizer
extension ReceivedCompetenciesTableViewController: UIGestureRecognizerDelegate {
    @objc
    private func tapRecognizer(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            guard let indexPath = tableView.indexPathForRow(at: recognizer.location(in: tableView)) else {
                return
            }
            
            let competenceVC = CompetenceTableViewController()
            competenceVC.configure(with: subscribedCompetenceList[indexPath.row])
            navigationController?.pushViewController(competenceVC, animated: true)
        }
    }
}
