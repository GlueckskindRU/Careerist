//
//  CompetenceTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CompetenceTableViewController: UITableViewController {
    private var captionData: [String] = []
    private var competence: CompetenceWithReadingStatus?
    private var coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    
    lazy private var logInBarButtonItem: UIBarButtonItem = {
        let icon = UIImage(named: Assets.login.rawValue)
        return UIBarButtonItem(image: icon, style: UIBarButtonItem.Style.plain, target: self, action: #selector(logInTapped(sender:)))
    }()
    
    lazy private var customBackButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Assets.backArrow.rawValue),
                               style: UIBarButtonItem.Style.plain,
                               target: self,
                               action: #selector(customBackButtonTapped(_:))
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionData = CabinetModel.fetchCompetenceData()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.register(CompetenceCell.self, forCellReuseIdentifier: CellIdentifiers.completenceCell.rawValue)
        
        tableView.tableFooterView = UIView()
        let headerView = HeaderViewWithInfoText()
        headerView.configure(infoText: "Непрочитанные статьи или советы дня отмечаются восклицательным знаком")
        tableView.setAndLayoutTableHeaderView(header: headerView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
        
        navigationItem.title = competence?.competences.name
        navigationItem.hidesBackButton = false
        navigationItem.leftBarButtonItem = customBackButton
        
        if let tintColor = UIColor(named: "cabinetTintColor") {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: tintColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
            ]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (UIApplication.shared.delegate as! AppDelegate).appManager.isAuhorized() {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = logInBarButtonItem
        }
        
        setupNavigationMultilineTitle()
        refreshReadingStatuses()
    }
    
    func configure(with competence: CompetenceWithReadingStatus) {
        self.competence = competence
    }
}

// MARK: - TableView DataSource
extension CompetenceTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return captionData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let competence = competence,
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.completenceCell.rawValue, for: indexPath) as? CompetenceCell
            else {
            return UITableViewCell()
        }
        
        switch captionData[indexPath.row] {
        case "Ваши советы дня":
            cell.configure(with: captionData[indexPath.row], and: competence.hasNewAdvice)
        case "Ваши статьи":
            cell.configure(with: captionData[indexPath.row], and: competence.hasNewArticle)
        default:
            cell.configure(with: captionData[indexPath.row], and: false)
        }
        
        return cell
    }
}

extension CompetenceTableViewController {
    private func refreshReadingStatuses() {
        guard
            let competence = competence else {
            return
        }
        
        let newArticlesStatusArray = competence.subscribedIndicators.map { hasNewArticle(under: $0) }
        let newArticleStatus = newArticlesStatusArray.contains(true)
        
        let newAdvicesStatusArray = competence.subscribedIndicators.map { hasNewAdvice(under: $0) }
        let newAdviceStatus = newAdvicesStatusArray.contains(true)
        
        self.competence = CompetenceWithReadingStatus(competence.competences, competence.subscribedIndicators, newArticleStatus, newAdviceStatus)
        tableView.reloadData()
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
extension CompetenceTableViewController: UIGestureRecognizerDelegate {
    @objc
    private func tapRecognizer(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            guard
                let competence = competence,
                let indexPath = tableView.indexPathForRow(at: recognizer.location(in: tableView))
                else {
                return
            }
            
            let assetType: ArticleType
            
            switch captionData[indexPath.row] {
            case "Ваши советы дня":
                assetType = ArticleType.advice
            case "Ваши статьи":
                assetType = ArticleType.article
            default:
                return
            }
            
            let destinationVC = ListOfReceivedArticlesAndAdvices()
            destinationVC.configure(with: competence.competences, as: assetType)
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}
