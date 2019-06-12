//
//  ScheduleTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

typealias optionalVoid = (() -> Void)?

class ScheduleTableViewController: UITableViewController {
    private var articlesSchedule: SubscriptionArticleSchedule?
    private var advicesSchedule: SubscriptionAdviceSchedule?
    
    lazy private var logInBarButtonItem: UIBarButtonItem = {
        let icon = UIImage(named: Assets.login.rawValue)
        return UIBarButtonItem(image: icon, style: UIBarButtonItem.Style.plain, target: self, action: #selector(logInTapped(sender:)))
    }()
    
    lazy private var saveBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonTapped(sender:)))
    }()

    lazy private var customBackButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Assets.backArrow.rawValue),
                               style: UIBarButtonItem.Style.plain,
                               target: self,
                               action: #selector(back(sender:))
        )
    }()
    
    private var isSaved: Bool = true {
        didSet {
            if isSaved {
                saveBarButtonItem.isEnabled = false
            } else {
                if self.isEditing {
                    saveBarButtonItem.isEnabled = false
                } else {
                    saveBarButtonItem.isEnabled = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.register(UINib(nibName: String(describing: ArticlesScheduleCell.self), bundle: nil), forCellReuseIdentifier: CellIdentifiers.articlesSchedule.rawValue)
        tableView.register(UINib(nibName: String(describing: AdvicesScheduleCell.self), bundle: nil), forCellReuseIdentifier: CellIdentifiers.advicesSchedule.rawValue)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "График развития"
        navigationItem.rightBarButtonItems = [saveBarButtonItem]
        saveBarButtonItem.isEnabled = AppManager.shared.isAuhorized() && !isSaved
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = customBackButton
        
        if let tintColor = UIColor(named: "cabinetTintColor") {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: tintColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
            ]
        }
        
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !(UIApplication.shared.delegate as! AppDelegate).appManager.isAuhorized() {
            navigationItem.rightBarButtonItems?.insert(logInBarButtonItem, at: 0)
        }
        
        setupNavigationMultilineTitle()
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource
extension ScheduleTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.advicesSchedule.rawValue, for: indexPath) as! AdvicesScheduleCell
            
            guard let advicesSchedule = advicesSchedule else {
                return cell
            }
            
            cell.configure(with: advicesSchedule, delegate: self, loggedUser: AppManager.shared.isAuhorized())
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.articlesSchedule.rawValue, for: indexPath) as! ArticlesScheduleCell
            
            guard let articleSchedule = articlesSchedule else {
                return cell
            }
            
            cell.configure(with: articleSchedule, delegate: self, loggedUser: AppManager.shared.isAuhorized())
            
            return cell
        }
    }
}

// MARK: - receiving and saving settings data
extension ScheduleTableViewController {
    private func fetchData() {
        guard let currentUser = AppManager.shared.getCurrentUser() else {
            articlesSchedule = SubscriptionArticleSchedule()
            advicesSchedule = SubscriptionAdviceSchedule()
            return
        }
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.articlesSchedule) {
            (result: Result<SubscriptionArticleSchedule>) in
            
            switch result {
            case .success(let articlesSchedule):
                self.articlesSchedule = articlesSchedule
                
                FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.advicesSchedule) {
                    (result: Result<SubscriptionAdviceSchedule>) in
                    
                    switch result {
                    case .success(let advicesSchedule):
                        self.advicesSchedule = advicesSchedule
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
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
            case .failure(let error):
                DispatchQueue.main.async {
                    activityIndicator.stop()
                    let alertDialog = AlertDialog(title: nil, message: error.getError())
                    alertDialog.showAlert(in: self, completion: nil)
                }
            }
        }
    }
    
    @objc
    private func saveButtonTapped(sender: UIBarButtonItem) {
        saveData(completion: nil)
    }
    
    private func saveData(completion: optionalVoid) {
        guard
        let articlesSchedule = articlesSchedule,
        let advicesSchedule = advicesSchedule,
        let currentUser = AppManager.shared.getCurrentUser() else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        FirebaseController.shared.getDataController().saveData(articlesSchedule, with: currentUser.id, in: DBTables.articlesSchedule) {
            (result: Result<SubscriptionArticleSchedule>) in
            
            switch result {
            case .success(_):
                FirebaseController.shared.getDataController().saveData(advicesSchedule, with: currentUser.id, in: DBTables.advicesSchedule) {
                    (result: Result<SubscriptionAdviceSchedule>) in
                    
                    activityIndicator.stop()
                    
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.isSaved = true
                            guard let completion = completion else {
                                let alertDialog = AlertDialog(title: nil, message: "Ваш график развития успешно сохранён!")
                                return alertDialog.showAlert(in: self, completion: nil)
                            }

                            completion()
                        }
                    case .failure(let error):                    
                        DispatchQueue.main.async {
                            let alertDialog = AlertDialog(title: nil, message: error.getError())
                            alertDialog.showAlert(in: self, completion: nil)
                        }
                    }
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
    
    @objc
    private func back(sender: UIBarButtonItem) {
        if isSaved {
            _ = navigationController?.popViewController(animated: true)
        } else {
            showQuitingAlertDialog {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func showQuitingAlertDialog(quitingCompletion: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: "Сохранить изменения?", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "Да", style: UIAlertAction.Style.default) {
            _ in
            self.saveData(completion: quitingCompletion)
        }
        
        let quitWithoutSavingAction = UIAlertAction(title: "Нет", style: UIAlertAction.Style.cancel) {
            _ in
            quitingCompletion()
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(quitWithoutSavingAction)
        alertController.preferredAction = saveAction
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Schedule Cell Delegate Protocol
extension ScheduleTableViewController: ScheduleCellDelegateProtocol {
    func setSchedulingFrequency(_ frequency: DayOfWeek, for type: ArticleType) {
        switch type {
        case .article:
            let newSchedule: SubscriptionArticleSchedule
            if articlesSchedule == nil {
                newSchedule = SubscriptionArticleSchedule(frequency: frequency, hour: 0, minute: 0, withQuestions: true)
                isSaved = false
            } else {
                newSchedule = SubscriptionArticleSchedule(frequency: frequency, hour: articlesSchedule!.hour, minute: articlesSchedule!.minute, withQuestions: articlesSchedule!.withQuestions)
                isSaved = newSchedule == articlesSchedule!
            }
            
            articlesSchedule = newSchedule
        case .advice:
            let newSchedule: SubscriptionAdviceSchedule
            if advicesSchedule == nil {
                newSchedule = SubscriptionAdviceSchedule(frequency: frequency, hour: 0, minute: 0)
                isSaved = false
            } else {
                newSchedule = SubscriptionAdviceSchedule(frequency: frequency, hour: advicesSchedule!.hour, minute: advicesSchedule!.minute)
                isSaved = newSchedule == advicesSchedule!
            }
            
            advicesSchedule = newSchedule
        }
    }
    
    func callTimePicker(for type: ArticleType) {
        let hour: Int
        let minute: Int
        
        switch type {
        case .article:
            if let articlesSchedule = articlesSchedule {
                hour = articlesSchedule.hour
                minute = articlesSchedule.minute
            } else {
                hour = 0
                minute = 0
            }
            
            let articlesTimePickerVC = TimePickerViewController()
            articlesTimePickerVC.configure(hour: hour, minute: minute, delegate: self, as: .article)
            articlesTimePickerVC.modalTransitionStyle = .crossDissolve
            articlesTimePickerVC.modalPresentationStyle = .overCurrentContext
            present(articlesTimePickerVC, animated: true, completion: nil)
        case .advice:
            if let advicesSchedule = advicesSchedule {
                hour = advicesSchedule.hour
                minute = advicesSchedule.minute
            } else {
                hour = 0
                minute = 0
            }
            
            let advicesTimePickerVC = TimePickerViewController()
            advicesTimePickerVC.configure(hour: hour, minute: minute, delegate: self, as: .advice)
            advicesTimePickerVC.modalTransitionStyle = .crossDissolve
            advicesTimePickerVC.modalPresentationStyle = .overCurrentContext
            present(advicesTimePickerVC, animated: true, completion: nil)
        }
    }
    
    func testQuestionsValueChanged(to value: Bool, for type: ArticleType) {
        switch type {
        case .article:
            let newSchedule: SubscriptionArticleSchedule
            if articlesSchedule == nil {
                newSchedule = SubscriptionArticleSchedule(frequency: [], hour: 0, minute: 0, withQuestions: value)
                isSaved = false
            } else {
                newSchedule = SubscriptionArticleSchedule(frequency: articlesSchedule!.frequency, hour: articlesSchedule!.hour, minute: articlesSchedule!.minute, withQuestions: value)
                isSaved = newSchedule == articlesSchedule!
            }
            
            articlesSchedule = newSchedule
        default:
            return
        }
    }
}

extension ScheduleTableViewController: TimeSaveDelegateProtocol {
    func setTime(hour: Int, minute: Int, as type: ArticleType) {
        switch type {
        case .advice:
            let newSchedule: SubscriptionAdviceSchedule
            if advicesSchedule == nil {
                newSchedule = SubscriptionAdviceSchedule(frequency: [], hour: hour, minute: minute)
                isSaved = false
            } else {
                newSchedule = SubscriptionAdviceSchedule(frequency: advicesSchedule!.frequency, hour: hour, minute: minute)
                isSaved = newSchedule == advicesSchedule!
            }
            
            advicesSchedule = newSchedule
        case .article:
            let newSchedule: SubscriptionArticleSchedule
            if articlesSchedule == nil {
                newSchedule = SubscriptionArticleSchedule(frequency: [], hour: hour, minute: minute, withQuestions: true)
                isSaved = false
            } else {
                newSchedule = SubscriptionArticleSchedule(frequency: articlesSchedule!.frequency, hour: hour, minute: minute, withQuestions: articlesSchedule!.withQuestions)
                isSaved = newSchedule == articlesSchedule!
            }
            
            articlesSchedule = newSchedule
        }
        
        tableView.reloadData()
    }
}
