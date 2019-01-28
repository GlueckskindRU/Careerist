//
//  CabinetTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import CoreData

typealias CompetenceWithReadingStatus = (competences: CharacteristicsModel, subscribedIndicators: Set<String>, hasNewArticle: Bool, hasNewAdvice: Bool)
typealias IndicatorsDictionary = [String: Set<CharacteristicsModel>]

class CabinetTableViewController: UITableViewController {
    private var sectionsItems: [CabinetModel] = []
    private var subscribedCompetenceList: [CompetenceWithReadingStatus] = []
    private var initialData: [CabinetModel] = []
    private var coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Личный кабинет"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? CompetenceTableViewController,
            let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        destination.configure(with: subscribedCompetenceList[indexPath.row])
    }
}

// MARK: - TableView DataSource
extension CabinetTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = sectionsItems[section].name
        
        if let sectionIndex = initialData.index(where: { $0.name == sectionName }) {
            if initialData[sectionIndex].hasChildern {
                return subscribedCompetenceList.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cabinet Cell", for: indexPath) as! CabinetCell
        
        cell.configure(with: subscribedCompetenceList[indexPath.row])
        
        return cell
    }
}

// MARK: - TableView Delegate
extension CabinetTableViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CabinetSectionView()
        view.configure(with: sectionsItems[section].name, as: self)
        
        return view
    }
}

// MARK: - CabinetSection Delegate Protocol
extension CabinetTableViewController: CabinetSectionDelegateProtocol {
    func pushViewController(with title: String) {
        let activeSection = sectionsItems.first { $0.name == title }
        guard let selectedSection = activeSection else {
            return
        }
        let viewController:  UIViewController
        
        switch selectedSection.name {
        case "Мои достижения":
            viewController = AchievementsTableViewController()
        case "График развития":
            viewController = ScheduleTableViewController()
        case "Мои записи":
            viewController = NotesTableViewController()
        case "Мои компетенции":
            if subscribedCompetenceList.isEmpty {
                let alertDialog = AlertDialog(title: nil, message: "Здесь будут отображены компетенции, на которые вы можете подписаться на вкладке \'Основное меню\'")
                alertDialog.showAlert(in: self, completion: nil)
            }
            return
        default:
            return
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CabinetTableViewController {
    private func refreshUI() {
        initialData = CabinetModel.fetchInitialData()
        
        sectionsItems = initialData.filter { $0.level == .zero }
        
        guard let currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser() else {
            return
        }
        
        subscribedCompetenceList = []
        
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
                    if let subscribedIndicatorsIDs = currentUser.subscribedCharacteristics[competence.id] {
                        self.fillCompetenceList(for: competence, indicatorIDs: subscribedIndicatorsIDs)
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
