//
//  CharacteristicsArticlesTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 12/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class CharacteristicsArticlesTableViewController: UITableViewController {
    private var articles: [Article] = []
    private var parentID: String?
    
    func configure(with parentID: String) {
        self.parentID = parentID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        refreshUI()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editArticles(sender:)))
        editBarButtonItem.isEnabled = !articles.isEmpty
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewArticle(sender:)))
        navigationItem.rightBarButtonItems = [addBarButtonItem, editBarButtonItem]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshUI()
    }
}

// MARK: - TableView DataSource
extension CharacteristicsArticlesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.characteristicArticleCell.rawValue, for: indexPath) as! CharacteristicsArticlesCell
        
        cell.configure(with: articles[indexPath.row])
        
        return cell
    }
}

// MARK: - TableView Delegate
extension CharacteristicsArticlesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let editArticleVC = NewCharacteristicArticleTableViewController()
        editArticleVC.configure(with: articles[indexPath.row], as: indexPath.row, parentID: parentID)
        navigationController?.pushViewController(editArticleVC, animated: true)
    }
}

// MARK: - UI creation and refreshing
extension CharacteristicsArticlesTableViewController {
    private func refreshUI() {
        let footerText = "К сожалению для данного индикатора статей ещё пока нет."
        let actitivityIndicator = ActivityIndicator()
        actitivityIndicator.start()
        
        guard let parentID = parentID else {
            articles = []
            tableView.tableFooterView = TableFooterView.shared.create(with: footerText, in: self.view, empty: true)
            return
        }
        
        FirebaseController.shared.getDataController().fetchArticles(from: DBTables.characteristics, by: parentID) {
            (result: Result<[Article]>) in
            
            actitivityIndicator.stop()
            switch result {
            case .success(let data):
                self.articles = data
                self.tableView.reloadData()
                self.tableView.tableFooterView = TableFooterView.shared.create(with: footerText, in: self.view, empty: self.articles.isEmpty)
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
}

// MARK: - Navigation Items processing
extension CharacteristicsArticlesTableViewController {
    @objc
    private func addNewArticle(sender: UIBarButtonItem) {
        let sequenceToPass: Int
        if articles.isEmpty {
            sequenceToPass = 1
        } else {
            sequenceToPass = articles.count + 1
        }
        let newArticleVC = NewCharacteristicArticleTableViewController()
        newArticleVC.configure(with: nil, as: sequenceToPass, parentID: parentID)
        
        navigationController?.pushViewController(newArticleVC, animated: true)
    }
    
    @objc
    private func editArticles(sender: UIBarButtonItem) {
        print("edit articles button tapped")
    }
}
