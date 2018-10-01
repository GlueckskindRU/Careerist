//
//  CabinetTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CabinetTableViewController: UITableViewController {
    private var sectionsItems: [CabinetModel] = []
    private var rowItems: [CharacteristicsModel] = []
    private var initialData: [CabinetModel] = []
    
    override func viewDidLoad() {
        refreshUI()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
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

// MARK: - TableView DataSource
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
            viewController = DevelopmentTableViewController()
        case "Мои записи":
            viewController = NotesTableViewController()
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
        
        FirebaseController.shared.getDataController().fetchCharacteristics(of: CharacteristicsLevel.competences) {
            (result: Result<[CharacteristicsModel]>) in
            
            switch result {
            case .success(let competences):
                self.rowItems = competences
                self.tableView.reloadData()
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
}
