//
//  CompetenciesTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 03/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class CompetenciesTableViewController: UITableViewController {
    private var competencies: [CharacteristicsModel] = []
    private var groupOfCompetencies: CharacteristicsModel?
    
    lazy private var logInBarButtonItem: UIBarButtonItem = {
        let icon = UIImage(named: Assets.login.rawValue)
        return UIBarButtonItem(image: icon, style: UIBarButtonItem.Style.plain, target: self, action: #selector(logInTapped(sender:)))
    }()
    
    lazy private var customBackButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Assets.backArrow.rawValue),
                               style: UIBarButtonItem.Style.plain,
                               target: self,
                               action: #selector(customBackButtonTapped(_:))
                                )
    }()
    
    func configure(for group: CharacteristicsModel) {
        self.groupOfCompetencies = group
        fetchCompetencies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.register(CompetenciesCell.self, forCellReuseIdentifier: CellIdentifiers.completenceCell.rawValue)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.tableFooterView = UIView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self

        guard
            let group = groupOfCompetencies,
            let groupHelper = CharacteristicUIHelper(with: group.name)
            else {
                return
        }
        
        let headerView = HeaderViewWithInfoText()
        headerView.configure(infoText: groupHelper.getGroupInfo())
        tableView.setAndLayoutTableHeaderView(header: headerView)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = customBackButton
        
        navigationItem.title = group.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (UIApplication.shared.delegate as! AppDelegate).appManager.isAuhorized() {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = logInBarButtonItem
        }
        
        setupNavigationMultilineTitle()
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource
extension CompetenciesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.completenceCell.rawValue, for: indexPath) as? CompetenciesCell,
            let group = self.groupOfCompetencies,
            let groupHelper = CharacteristicUIHelper(with: group.name)
            else {
            return UITableViewCell()
        }
        
        cell.configure(with: competencies[indexPath.row].name, bgColor: groupHelper.getBGColor())
        
        return cell
    }
}

// MARK: - Gesture Tap Recognizer
extension CompetenciesTableViewController: UIGestureRecognizerDelegate {
    @objc
    private func tapRecognizer(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            guard
                let indexPath = tableView.indexPathForRow(at: recognizer.location(in: tableView)),
                let group = groupOfCompetencies
                else {
                return
            }
            
            let indicatorsVC = IndicatorsTableViewController()
            indicatorsVC.configure(for: competencies[indexPath.row], with: group)
            navigationController?.pushViewController(indicatorsVC, animated: true)
        }
    }
}

// MARK: - Fetching Data
extension CompetenciesTableViewController {
    private func fetchCompetencies() {
        guard let group = self.groupOfCompetencies else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        FirebaseController.shared.getDataController().fetchChildernCharacteristicsOf(group.id) {
            (result: Result<[CharacteristicsModel]>) in
            
            switch result {
            case .success(let data):
                self.competencies = data
                self.tableView.reloadData()
                activityIndicator.stop()
            case .failure(let error):
                activityIndicator.stop()
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
}
