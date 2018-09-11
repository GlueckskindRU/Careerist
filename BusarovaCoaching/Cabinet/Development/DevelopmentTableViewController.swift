//
//  DevelopmentTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class DevelopmentTableViewController: UITableViewController {
    private var developmentData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        developmentData = CabinetModel.fetchDevelopmentSettings()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(DevelopmentCell.self, forCellReuseIdentifier: "Development Cell")
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "График развития"
    }
}

extension DevelopmentTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return developmentData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Development Cell", for: indexPath) as! DevelopmentCell
        
        let enhanced: Bool = indexPath.row == 1 ? true : false
        
        cell.configure(with: developmentData[indexPath.row], as: enhanced)
        
        return cell
    }
}

extension DevelopmentTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight: CGFloat = indexPath.row == 1 ? 155 : 115
        
        return rowHeight
    }
}
