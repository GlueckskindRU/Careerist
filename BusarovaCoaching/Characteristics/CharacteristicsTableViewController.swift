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
    private var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchGroupsOfCompetentions()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.tableFooterView = UIView()
        
        tableView.insetsContentViewsToSafeArea = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? CharacteristicsArticlesTableViewController,
            let indexPath = self.indexPath else {
                return
        }
        
        destination.configure(with: characteristics[indexPath.row].id)
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
        case .indicatorsOfCompetentions:
            cellIdentifier = CellIdentifiers.characteristicCellLevel2.rawValue
        case .competences:
            cellIdentifier = CellIdentifiers.characteristicCellLevel1.rawValue
        case .groupOfCompetentions:
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
                if characterictic.level != CharacteristicsLevel.indicatorsOfCompetentions {
                    expandMenu(with: characterictic.id, at: index)
                } else {
                    self.indexPath = indexPath
                    performSegue(withIdentifier: SegueIdentifiers.characteristicsArticle.rawValue, sender: self)
                }
            } else {
                if characterictic.level == .competences {
                    collapseMenu(with: characterictic.id, at: index)
                }
                if characterictic.level == .groupOfCompetentions {
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
    private func fetchGroupsOfCompetentions() {
        let actitivityIndicator = ActivityIndicator()
        actitivityIndicator.start()
        FirebaseController.shared.getDataController().fetchCharacteristics(of: CharacteristicsLevel.groupOfCompetentions) {
            (result: Result<[CharacteristicsModel]>) in
            
            actitivityIndicator.stop()
            switch result {
            case .success(let data):
                self.characteristics = data
                self.tableView.reloadData()
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
    
    private func expandMenu(with parentId: String, at index: Int) {
        let actitivityIndicator = ActivityIndicator()
        actitivityIndicator.start()
        FirebaseController.shared.getDataController().fetchChildernCharacteristicsOf(parentId) {
            (result: Result<[CharacteristicsModel]>) in
            
            switch result {
            case .success(let data):
                self.characteristics[index].collapsed = false
                self.tableView.beginUpdates()
                for i in index+1..<index+data.count+1 {
                    self.characteristics.insert(data[i-index-1], at: i)
                    self.tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                }
                self.tableView.endUpdates()
                self.tableView.reloadData()
                actitivityIndicator.stop()
            case .failure(let error):
                actitivityIndicator.stop()
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
    
    private func collapseMenu(with parentID: String, at index: Int) {
        let actitivityIndicator = ActivityIndicator()
        actitivityIndicator.start()
        
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
        actitivityIndicator.stop()
    }
}
