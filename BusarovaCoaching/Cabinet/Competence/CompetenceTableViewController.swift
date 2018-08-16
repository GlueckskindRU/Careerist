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
    private var navigationTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionData = CabinetModel.fetchCompetenceData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        navigationItem.title = navigationTitle
    }
    
    func configure(with title: String) {
        self.navigationTitle = title
    }
}


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
