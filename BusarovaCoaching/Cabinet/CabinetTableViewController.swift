//
//  CabinetTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CabinetTableViewController: UITableViewController, DataControllerProtocol {
    private var sectionsItems: [CabinetModel] = []
    private var rowItems: [CabinetModel] = []
    private var initialData: [CabinetModel] = []
    internal var dataController: DataController!
    
    override func viewDidLoad() {
        initialData = CabinetModel.fetchInitialData()
        
        sectionsItems = initialData.filter { $0.level == .zero }
        rowItems = initialData.filter { $0.level == .one }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Личный кабинет"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? CompetenceTableViewController,
            let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        destination.configure(with: rowItems[indexPath.row].name)
    }
}

extension CabinetTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = sectionsItems[section].name
        
        if let sectionIndex = initialData.index(where: { $0.name == sectionName }) {
            if initialData[sectionIndex].hasChildern {
                return rowItems.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cabinet Cell", for: indexPath) as! CabinetCell
        
        cell.configure(with: rowItems[indexPath.row].name)
        
        return cell
    }
}

extension CabinetTableViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CabinetSectionView()
        view.configure(with: sectionsItems[section].name, as: self)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

extension CabinetTableViewController: CabinetSectionDelegateProtocol {
    func pushViewController(with title: String) {
        let activeSection = sectionsItems.first { $0.name == title }
        guard let selectedSection = activeSection else {
            return
        }
        let viewController: DataControllerProtocol
        
        switch selectedSection.name {
        case "Мои достижения":
            viewController = AchievementsTableViewController()
        case "График развития":
            viewController = DevelopmentTableViewController()
        case "Мои записи":
            viewController = NotesTableViewController()
        default:
            return
        }
        
        viewController.configure(with: dataController)
        navigationController?.pushViewController(viewController as! UIViewController, animated: true)
    }
    
    
}
