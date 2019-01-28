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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionData = CabinetModel.fetchCompetenceData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        navigationItem.title = competence?.competences.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshReadingStatuses()
    }
    
    func configure(with competence: CompetenceWithReadingStatus) {
        self.competence = competence
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let competence = competence,
            let destination = segue.destination as? ListOfReceivedArticlesAndAdvices,
            let indexPath = tableView.indexPathForSelectedRow else {
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
        
        destination.configure(with: competence.competences, as: assetType)
    }
}

// MARK: - TableView DataSource
extension CompetenceTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return captionData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let competence = competence else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Competence Cell", for: indexPath) as! CompetenceCell
        
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
