//
//  CharacteristicsTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 27/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol CharacteristicsCellProtocol {
    func configure(with characteristics: CharacteristicsModel)
}

class CharacteristicsTableViewController: UITableViewController {
    private var characteristics: [CharacteristicsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchLevelZero()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.tableFooterView = UIView()
        
        tableView.insetsContentViewsToSafeArea = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
    }
}

extension CharacteristicsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let characteristicToPass = characteristics[indexPath.row]
        let cellIdentifier: String
        
        switch characteristicToPass.level {
        case 2:
            cellIdentifier = CellIdentifiers.characteristicCellLevel2.rawValue
        case 1:
            cellIdentifier = CellIdentifiers.characteristicCellLevel1.rawValue
        default:
            cellIdentifier = CellIdentifiers.characteristicCellLevel0.rawValue
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CharacteristicsCellProtocol
        cell.configure(with: characteristicToPass)
        
        return cell as! UITableViewCell
    }
}

extension CharacteristicsTableViewController: UIGestureRecognizerDelegate {
    @objc
    private func tapRecognizer(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            guard let indexPath = tableView.indexPathForRow(at: recognizer.location(in: tableView)) else {
                return
            }
            
            let characterictic = characteristics[indexPath.row]
            let index = indexPath.row
            
            if characterictic.collapsed {
                if characterictic.level < 2 {
                    expandMenu(with: characterictic.id, at: index)
                } else {
                    performSegue(withIdentifier: SegueIdentifiers.characteristicsArticle.rawValue, sender: self)
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
}

extension CharacteristicsTableViewController {
    private func fetchLevelZero() {
        FirebaseController.shared.getDataController().fetchInitialCharacteristics() {
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
        FirebaseController.shared.getDataController().fetchChildernCharacteristicsOf(parentId) {
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
