//
//  CabinetTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import CoreData

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
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = UIView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
        
        let headerView = HeaderViewWithInfoText()
        headerView.configure(infoText: "\r\n")
        tableView.setAndLayoutTableHeaderView(header: headerView)
        
        navigationItem.title = "Личный кабинет"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationMultilineTitle()
        refreshUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationMultilineTitle()
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
        ]
    }
}

// MARK: - TableView DataSource
extension CabinetTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cabinet Cell", for: indexPath) as? CabinetCell
            else {
                return UITableViewCell()
        }
        
        cell.configure(with: sectionsItems[indexPath.row].name)
        
        return cell
    }
}

// MARK: - Gesture Tap Recognizer
extension CabinetTableViewController: UIGestureRecognizerDelegate {
    @objc
    private func tapRecognizer(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            guard let indexPath = tableView.indexPathForRow(at: recognizer.location(in: tableView)) else {
                return
            }
            
            let viewController: UIViewController
            
            switch sectionsItems[indexPath.row].name {
            case "Мои достижения":
                viewController = AchievementsTableViewController()
            case "График развития":
                viewController = ScheduleTableViewController()
            case "Мои записи":
                viewController = NotesTableViewController()
            case "Мои компетенции":
                viewController = ReceivedCompetenciesTableViewController()
            default:
                return
            }
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension CabinetTableViewController {
    func refreshUI() {
        initialData = CabinetModel.fetchInitialData()
        
        sectionsItems = initialData.filter { $0.level == .zero }

        tableView.reloadData()
    }
}
