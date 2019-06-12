//
//  IndicatorsTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 06/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class IndicatorsTableViewController: UITableViewController {
    private var indicators: [CharacteristicsModel] = []
    private var groupOfCompetencies: CharacteristicsModel?
    private var competence: CharacteristicsModel?
    
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
    
    func configure(for competence: CharacteristicsModel, with parent: CharacteristicsModel) {
        self.groupOfCompetencies = parent
        self.competence = competence
        fetchIndicators()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.register(IndicatorsCell.self, forCellReuseIdentifier: CellIdentifiers.indicatorCell.rawValue)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.tableFooterView = UIView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
        
        let hintText = "Нажмите на индикатор и подпишитесь на получение информации по нему."
        
        let headerView = HeaderViewWithInfoText()
        headerView.configure(infoText: hintText)
        tableView.setAndLayoutTableHeaderView(header: headerView)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = customBackButton
        
        navigationItem.title = competence?.name
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

// MARK: TableView DataSource
extension IndicatorsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indicators.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.indicatorCell.rawValue, for: indexPath) as? IndicatorsCell,
            let group = self.groupOfCompetencies,
            let groupHelper = CharacteristicUIHelper(with: group.name)
            else {
                return UITableViewCell()
        }
        
        let bgColor = AppManager.shared.isSubscribed(to: indicators[indexPath.row])
                    ? groupHelper.getSubscribedBGColor()
                    : groupHelper.getBGColor()
        
        cell.configure(with: indicators[indexPath.row], bgColor: bgColor)
        
        return cell
    }
}

// MARK: - Gesture Tap Recognizer
extension IndicatorsTableViewController: UIGestureRecognizerDelegate {
    @objc
    private func tapRecognizer(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            guard let indexPath = tableView.indexPathForRow(at: recognizer.location(in: tableView)) else {
                return
            }
            
            if AppManager.shared.currentUserHasPermission(to: DBTables.articles, with: indicators[indexPath.row].parentID) {
                let characteristicsArticlesVC = CharacteristicsArticlesTableViewController()
                characteristicsArticlesVC.configure(with: indicators[indexPath.row].id, competenceID: indicators[indexPath.row].parentID)
                navigationController?.pushViewController(characteristicsArticlesVC, animated: true)
            } else {
                indicateSubscriptionDialog(for: indicators[indexPath.row])
            }
        }
    }
}

// MARK: - Fetching Data
extension IndicatorsTableViewController {
    private func fetchIndicators() {
        guard let competence = competence else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        FirebaseController.shared.getDataController().fetchChildernCharacteristicsOf(competence.id) {
            (result: Result<[CharacteristicsModel]>) in
            
            switch result {
            case .success(let data):
                self.indicators = data
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

// MARK: - Subscriptions & Unsubscription
extension IndicatorsTableViewController {
    private func indicateSubscriptionDialog(for indicator: CharacteristicsModel) {
        guard AppManager.shared.isAuhorized() else {
            let error = AppError.notAuthorized
            let alertDialog = AlertDialog(title: nil, message: error.getError())
            return alertDialog.showAlert(in: self, completion: nil)
        }
 
        let activityIndicator = ActivityIndicator()
        
        let subscribeAction: Bool
        let message: String
        
        if AppManager.shared.isSubscribed(to: indicator) {
            subscribeAction = false
            message = "Вы действительно хотите отписаться от выбранного индикатора: \"\(indicator.name)\"?"
        } else {
            subscribeAction = true
            message = "Вы действительно хотите подписаться на выбранный индикатор: \"\(indicator.name)\"?"
        }
 
        let dialogController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let yesAction = UIAlertAction(title: "Да", style: UIAlertAction.Style.default) {
        alertAction in
         
            activityIndicator.start()
            
            AppManager.shared.performSubscriptionAction(to: indicator, subscribe: subscribeAction) {
            (result: Result<Bool>) in
     
                switch result {
                case .success(let subscribed):
                    DispatchQueue.main.async {
                        if subscribed {
                            self.tableView.reloadData()
                        }
                        activityIndicator.stop()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        activityIndicator.stop()
                        let alertDialog = AlertDialog(title: nil, message: error.getError())
                        alertDialog.showAlert(in: self, completion: nil)
                    }
                }
            }
        }

        let noAction = UIAlertAction(title: "Нет", style: UIAlertAction.Style.cancel, handler: nil)
 
        dialogController.addAction(yesAction)
        dialogController.addAction(noAction)
        
        dialogController.preferredAction = yesAction
        
        present(dialogController, animated: true, completion: nil)
    }
}
