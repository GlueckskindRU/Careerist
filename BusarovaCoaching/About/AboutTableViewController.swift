//
//  AboutTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 07/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    private var articlesTitles: [String] = WelcomeModel.menuItems
    private let cellIdentifier = "Menu Box Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.tableFooterView = UIView()
        
        tableView.register(AboutDesignedCell.self, forCellReuseIdentifier: cellIdentifier)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
        
        let headerView = HeaderViewWithInfoText()
        headerView.configure(infoText: "\r\n")
        tableView.setAndLayoutTableHeaderView(header: headerView)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.title = WelcomeModel.headerText
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationMultilineTitle()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationMultilineTitle()
        tableView.reloadData()
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
        ]
    }
}

// MARK: - TableView DataSource
extension AboutTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AboutDesignedCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: WelcomeModel.getMenuBoxImage(for: indexPath.row))
        
        return cell
    }
}

// MARK: - Gesture Recognizer Delegate
extension AboutTableViewController: UIGestureRecognizerDelegate {
    @objc
    private func tapRecognizer(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            guard let indexPath = tableView.indexPathForRow(at: recognizer.location(in: tableView)) else {
                return
            }
            
            let hardcodedArticleVC = AboutHardcodedArticleTableViewController()
            hardcodedArticleVC.configure(with: articlesTitles[indexPath.row])
            navigationController?.pushViewController(hardcodedArticleVC, animated: true)
        }
    }
}
