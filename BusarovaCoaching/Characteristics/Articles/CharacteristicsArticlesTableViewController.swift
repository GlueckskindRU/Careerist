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
    
    private var deletedArticles: Set<Article> = []
    
    lazy private var saveBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveArticles(sender:)))
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
    
    func configure(with parentID: String) {
        self.parentID = parentID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewArticle(sender:)))
        editButtonItem.title = "Настроить"
        saveBarButtonItem.isEnabled = !isSaved
        navigationItem.rightBarButtonItems = [editButtonItem, addBarButtonItem, saveBarButtonItem]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshUI()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            editButtonItem.title = "Завершить"
        } else {
            editButtonItem.title = "Настроить"
            if !isSaved {
                saveBarButtonItem.isEnabled = true
            }
        }
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
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard !articles.isEmpty else {
            return
        }
        
        let articleToMove = articles[sourceIndexPath.row]
        
        articles.remove(at: sourceIndexPath.row)
        articles.insert(articleToMove, at: destinationIndexPath.row)
        reorderSequences()
        isSaved = false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard !articles.isEmpty else {
                return
            }
            
            deletedArticles.insert(articles[indexPath.row])
            
            articles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            reorderSequences()
            isSaved = false
        }
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
                self.editButtonItem.isEnabled = !self.articles.isEmpty
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
            sequenceToPass = 0
        } else {
            sequenceToPass = articles.count
        }
        let newArticleVC = NewCharacteristicArticleTableViewController()
        newArticleVC.configure(with: nil, as: sequenceToPass, parentID: parentID)
        
        navigationController?.pushViewController(newArticleVC, animated: true)
    }
    
    @objc
    private func saveArticles(sender: UIBarButtonItem) {
        performArticleDeletion()
        saveArticles()
    }
}

// MARK: - auxiliaries functions
extension CharacteristicsArticlesTableViewController {
    private func reorderSequences() {
        guard !articles.isEmpty else {
            return
        }
        
        for index in articles.indices {
            articles[index].sequence = index
        }
    }
    
    private func performArticleDeletion() {
        guard !deletedArticles.isEmpty else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        for article in deletedArticles {
            activityIndicator.start()
            
            FirebaseController.shared.getDataController().fetchArticle(with: article.id) {
                (result: Result<[ArticleInside]>) in
                
                activityIndicator.stop()
                switch result {
                case .success(let data):
                    self.deleteArticleInside(data)
                    self.deleteArticle(with: article.id) {
                        guard
                            self.deletedArticles.contains(article),
                            let _ = self.deletedArticles.remove(article) else {
                                return
                        }
                        
                        self.isSaved = true
                    }
                case .failure(let error):
                    let alertDialog = AlertDialog(title: nil, message: error.getError())
                    alertDialog.showAlert(in: self, completion: nil)
                }
            }
        }
    }
    
    private func deleteArticleInside(_ articleInsideArray: [ArticleInside]) {
        guard !articleInsideArray.isEmpty else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        for element in articleInsideArray {
            activityIndicator.start()
            FirebaseController.shared.getDataController().deleteData(with: element.id, from: DBTables.articlesInside) {
                result in
                
                activityIndicator.stop()
                if result.isFailure {
                    guard let error = result.error else {
                        return
                    }
                    let alertDialog = AlertDialog(title: nil, message: error.getError())
                    alertDialog.showAlert(in: self, completion: nil)
                }
            }
        }
    }
    
    private func deleteArticle(with id: String, completion: @escaping () -> Void) {
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        FirebaseController.shared.getDataController().deleteData(with: id, from: DBTables.articles) {
            result in
            
            activityIndicator.stop()
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
    
    private func saveArticles() {
        guard !articles.isEmpty else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        for article in articles {
            activityIndicator.start()
            
            FirebaseController.shared.getDataController().saveData(article, with: article.id, in: DBTables.articles) {
                result in
                
                activityIndicator.stop()
                switch result {
                case .success(_):
                    self.isSaved = true
                case .failure(let error):
                    let alertDialog = AlertDialog(title: nil, message: error.getError())
                    alertDialog.showAlert(in: self, completion: nil)
                }
            }
        }
    }
}
