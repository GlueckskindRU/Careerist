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
    private var competence: CharacteristicsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionData = CabinetModel.fetchCompetenceData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        navigationItem.title = competence?.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: nil)
    }
    
    func configure(with competence: CharacteristicsModel) {
        self.competence = competence
    }
}

// MARK: - TableView DataSource
extension CompetenceTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return captionData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Competence Cell", for: indexPath) as! CompetenceCell
        
        cell.configure(with: captionData[indexPath.row])
        
        return cell
    }
}

// MARK: - TableView Delegate
extension CompetenceTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let competence = competence else {
            return
        }
        
        if captionData[indexPath.row] == "Ваши советы дня" {
            let listOfAdvicesVC = ListOfAdvicesTableViewController()
            listOfAdvicesVC.configure(with: competence)
            navigationController?.pushViewController(listOfAdvicesVC, animated: true)
        }
    }
}
