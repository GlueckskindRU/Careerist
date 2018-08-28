//
//  CharacteristicsTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 27/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol CharacteristicsProtocol {
    func menuCaptionTapped(on characterictic: CharacteristicsModel, at index: Int)
}

protocol CharacteristicsCellProtocol {
    func configure(with characteristics: CharacteristicsModel, as delegate: CharacteristicsProtocol, at index: Int)
}

class CharacteristicsTableViewController: UITableViewController {
    private var characteristics: [CharacteristicsModel] = []
    private var dataController: DataController!
    
    func configure(with dataController: DataController) {
        self.dataController = dataController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchLevelZero()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        tableView.tableFooterView = UIView()
        
        tableView.insetsContentViewsToSafeArea = true
    }
}

extension CharacteristicsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let characteristicToPass = characteristics[indexPath.row]
        let cell: CharacteristicsCellProtocol
        
        switch characteristicToPass.level {
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.characteristicCellLevel2.rawValue, for: indexPath) as! CharacteristicsCellProtocol
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.characteristicCellLevel1.rawValue, for: indexPath) as! CharacteristicsCellProtocol
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.characteristicCellLevel0.rawValue, for: indexPath) as! CharacteristicsCellProtocol
        }
        
        cell.configure(with: characteristicToPass, as: self, at: indexPath.row)
        
        return cell as! UITableViewCell
    }
}

extension CharacteristicsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tabBarHeight = (tabBarController?.tabBar.frame.height)!
        let totalHeight = tableView.bounds.height - tabBarHeight
        
        let rowHeight = totalHeight / CGFloat(characteristics.count)
        
        let minimumRowHeight: CGFloat = 36.0
        
        if rowHeight < minimumRowHeight {
            return minimumRowHeight
        } else {
            return rowHeight
        }
    }
    
}

extension CharacteristicsTableViewController: CharacteristicsProtocol {
    func menuCaptionTapped(on characterictic: CharacteristicsModel, at index: Int) {
        if characterictic.collapsed {
            if characterictic.level < 2 {
                expandMenu(with: characterictic.id, at: index)
            }
        } else {
            if characterictic.level == 1 {
                collapseMenu(with: characterictic.id, at: index)
            }
            if characterictic.level == 0 {
                let levelOneItems = characteristics.filter { $0.parentID == characterictic.id }
                
                for item in levelOneItems {
                    if let itemIndex = characteristics.index(where: { $0.id == item.id }) {
                        collapseMenu(with: item.id, at: itemIndex)
                    }
                }
                
                collapseMenu(with: characterictic.id, at: index)
            }
        }
    }
}

extension CharacteristicsTableViewController {
    private func fetchLevelZero() {
        dataController.fetchInitialCharacteristics() {
            (documents) in
            for document in documents {
                let data = document.data()
                self.characteristics.append(CharacteristicsModel(
                    id: document.documentID,
                    name: data["name"] as! String,
                    parentID: data["parentID"] as! String,
                    level: data["level"] as! Int
                ))
            }
            self.tableView.reloadData()
        }
    }
    
    private func expandMenu(with parentId: String, at index: Int) {
        dataController.fetchChildernCharacteristicsOf(parentId) {
            (documents) in
            
            self.characteristics[index].collapsed = false
            self.tableView.beginUpdates()
            for i in index+1..<index+documents.count+1 {
                let data = documents[i-index-1].data()
                let newCharacteristic = CharacteristicsModel(id: documents[i-index-1].documentID,
                                                             name: data["name"] as! String,
                                                             parentID: data["parentID"] as! String,
                                                             level: data["level"] as! Int
                )
                self.characteristics.insert(newCharacteristic, at: i)
                self.tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            }
            self.tableView.endUpdates()
            self.tableView.reloadData()
        }
    }
    
    private func collapseMenu(with parentID: String, at index: Int) {
        tableView.beginUpdates()
        
        for (i, _) in characteristics.enumerated().reversed() {
            if characteristics[i].parentID == parentID {
                characteristics.remove(at: i)
                tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .none)
            }
        }
        
        characteristics[index].collapsed = true
        tableView.endUpdates()
        tableView.reloadData()
    }
}
