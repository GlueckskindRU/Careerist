//
//  WelcomeTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class WelcomeTableViewController: UITableViewController {
    private var articles: [AboutArticlesModel] = []
    
    lazy private var logInBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Войти", style: .plain, target: self, action: #selector(logInTapped(sender:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        
        let footerView = UINib(nibName: String(describing: WelcomeFootterXIB.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WelcomeFootterXIB
        footerView.setup()
        tableView.tableFooterView = footerView
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        FirebaseController.shared.getDataController().fetchData(DBTables.aboutArticles) {
            (result: Result<[AboutArticlesModel]>) in

            activityIndicator.stop()
            switch result {
            case .success(let articles):
                self.articles = articles
                self.tableView.reloadData()
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
        
        navigationItem.rightBarButtonItem = logInBarButtonItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        logInBarButtonItem.isEnabled = !AppManager.shared.isAuhorized()
    }
}

// MARK: - TableView DataSource
extension WelcomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem Cell", for: indexPath) as! WelcomeTableCell

        cell.configure(with: articles[indexPath.row])

        return cell
    }
}

// MARK: - TableView Delegate
extension WelcomeTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

