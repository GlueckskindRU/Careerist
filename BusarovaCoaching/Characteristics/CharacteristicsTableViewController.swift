//
//  CharacteristicsTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 27/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CharacteristicsTableViewController: UITableViewController {
    private var characteristics: [CharacteristicsModel] = []
    
    lazy private var logInBarButtonItem: UIBarButtonItem = {
        let icon = UIImage(named: Assets.login.rawValue)
        return UIBarButtonItem(image: icon, style: UIBarButtonItem.Style.plain, target: self, action: #selector(logInTapped(sender:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchGroupsOfCompetentions()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: String(describing: CharacteristicCell.self), bundle: nil), forCellReuseIdentifier: CellIdentifiers.characteristicCell.rawValue)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.title = "Подписки"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (UIApplication.shared.delegate as! AppDelegate).appManager.isAuhorized() {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = logInBarButtonItem
        }
    }
}

// MARK: - TableView Data Source
extension CharacteristicsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.characteristicCell.rawValue, for: indexPath) as? CharacteristicCell,
            let groupHelper = CharacteristicUIHelper(with: characteristics[indexPath.row].name)
            else {
            return UITableViewCell()
        }
        
        cell.configure(title: groupHelper.getGroupName(),
                       info: groupHelper.getGroupInfo(),
                       block: groupHelper.getGroupBoxImage(),
                       arrow: groupHelper.getGroupArrowImage()
                        )

        return cell
    }
}

// MARK: - Gesture Recognizer Delegate
extension CharacteristicsTableViewController: UIGestureRecognizerDelegate {
    @objc
    private func tapRecognizer(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            guard let indexPath = tableView.indexPathForRow(at: recognizer.location(in: tableView)) else {
                return
            }
            
            let competenciesVC = CompetenciesTableViewController()
            competenciesVC.configure(for: characteristics[indexPath.row])
            navigationController?.pushViewController(competenciesVC, animated: true)
        }
    }
}


// MARK: - Menu expanding and collansing
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
}
