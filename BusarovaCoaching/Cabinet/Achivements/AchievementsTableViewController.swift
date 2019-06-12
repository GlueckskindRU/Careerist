//
//  AchievementsTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class AchievementsTableViewController: UITableViewController {
    private var achievementsData: [Achievements] = []
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.register(UINib(nibName: String(describing: AchivementsCell.self), bundle: nil), forCellReuseIdentifier: CellIdentifiers.achievementsCell.rawValue)
        
        tableView.tableFooterView = UIView()
        let headerView = HeaderViewWithInfoText()
        headerView.configure(infoText: "\r\n")
        tableView.setAndLayoutTableHeaderView(header: headerView)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = customBackButton
        
        navigationItem.title = "Мои достижения"
        
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
        fetchAchievements()
    }
}

// MARK: - TableView DataSource
extension AchievementsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievementsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.achievementsCell.rawValue, for: indexPath) as! AchivementsCell
        
        cell.configure(with: achievementsData[indexPath.row])
        
        return cell
    }
}

extension AchievementsTableViewController {
    private func fetchAchievements() {
        let noAchievementsMessage = "Здесь будут отображены Ваши достижения в ответах на тестовые вопросы по компетенциям, на которые Вы подписаны."
        guard
            let currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser() else {
                self.tableView.tableFooterView = TableFooterView.shared.create(with: noAchievementsMessage, in: self.view, empty: self.achievementsData.isEmpty)
                self.tableView.reloadData()
                return
        }
        
        achievementsData = []
        let currentRating = currentUser.rating
        let activityIndicator = ActivityIndicator()
        
        for rating in currentRating {
            activityIndicator.start()
            FirebaseController.shared.getDataController().fetchData(with: rating.competenceID, from: DBTables.characteristics) {
                (result: Result<CharacteristicsModel>) in
                
                if result.isSuccess, let competence = result.value {
                    let newAchievement = Achievements(competenceID: rating.competenceID,
                                                      competenceName: competence.name,
                                                      maxProgress: rating.totalPoints,
                                                      currentProgress: rating.earnedPoints
                                                        )
                    
                    self.achievementsData.append(newAchievement)
                    self.tableView.tableFooterView = TableFooterView.shared.create(with: noAchievementsMessage, in: self.view, empty: self.achievementsData.isEmpty)
                    self.tableView.reloadData()
                    activityIndicator.stop()
                }
            }
        }
        
        self.tableView.tableFooterView = TableFooterView.shared.create(with: noAchievementsMessage, in: self.view, empty: self.achievementsData.isEmpty)
        self.tableView.reloadData()
    }
}
