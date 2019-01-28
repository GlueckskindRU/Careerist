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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: String(describing: AchivementsCell.self), bundle: nil), forCellReuseIdentifier: CellIdentifiers.achievementsCell.rawValue)
        
        navigationItem.title = "Мои достижения"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.allowsSelection = false
        
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
