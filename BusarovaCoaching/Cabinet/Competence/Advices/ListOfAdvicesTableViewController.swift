//
//  ListOfAdvicesTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 08/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ListOfAdvicesTableViewController: UITableViewController {
    private var competence: CharacteristicsModel?
    private var listOfAdvices: [Article] = []
    
    func configure(with competence: CharacteristicsModel) {
        self.competence = competence
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListOfAdvicesCell.self, forCellReuseIdentifier: CellIdentifiers.listOfAdvicesCell.rawValue)
        
        navigationItem.title = competence?.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        refreshUI()
    }
}

// MARK: - TableView DataSource
extension ListOfAdvicesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfAdvices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.listOfAdvicesCell.rawValue, for: indexPath) as! ListOfAdvicesCell
        
        cell.configure(with: listOfAdvices[indexPath.row], as: indexPath.row + 1)
        
        return cell
    }
}

// MARK: - auxiliary functions
extension ListOfAdvicesTableViewController {
    private func refreshUI() {
        guard let competence = competence else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        FirebaseController.shared.getDataController().fetchChildernCharacteristicsOf(competence.id) {
            (result: Result<[CharacteristicsModel]>) in
            
            activityIndicator.stop()
            switch result {
            case .success(let arrayOfIndicators):
                for indicator in arrayOfIndicators {
                    activityIndicator.start()
                    
                    FirebaseController.shared.getDataController().fetchArticles(from: DBTables.characteristics, by: indicator.id) {
                        (advicesResult: Result<[Article]>) in
                        
                        activityIndicator.stop()
                        switch advicesResult {
                        case .success(let advices):
                            self.listOfAdvices.append(contentsOf: advices)
                            self.tableView.reloadData()
                            self.tableView.tableFooterView = TableFooterView.shared.create(with: "Вы ещё не получали ни одного совета дня по выбранной компетенции", in: self.view, empty: self.listOfAdvices.isEmpty)
                        case .failure(let error):
                            let alertDialog = AlertDialog(title: nil, message: error.getError())
                            alertDialog.showAlert(in: self, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
}
