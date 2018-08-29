//
//  AchievementsTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class AchievementsTableViewController: UITableViewController, DataControllerProtocol {
    private var achivementsData: [AchievementsModel] = []
    internal var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(AchivementsCell.self, forCellReuseIdentifier: "Achievement Cell")
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Мои достижения"
        
        dataController.fetchData(.achivements) {
            (documents) in
            for document in documents {
                let data = document.data()
                self.achivementsData.append(AchievementsModel(id: document.documentID,
                                                              name: data["name"] as! String,
                                                              imageURL: data["imageURL"] as! String
                                                            ))
            }
            self.tableView.reloadData()
        }
    }
}

extension AchievementsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achivementsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Achievement Cell", for: indexPath) as! AchivementsCell
        
        cell.configure(with: achivementsData[indexPath.row])
        
        return cell
    }
}

extension AchievementsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
