//
//  NewCharacteristicArticleTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 12/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

protocol ArticleSaveDelegateProtocol {
    func saveArticle(articleInside: ArticleInside, with articleInsideID: String?)
}

protocol ArticleTitleSaveProtocol {
    func saveArticleTitle(_ title: String)
}

protocol ArticleInsideElementsProtocol {
    func configure(with articleInside: ArticleInside?, as sequence: Int, delegate: ArticleSaveDelegateProtocol)
}

class NewCharacteristicArticleTableViewController: UITableViewController {
    private var articleInsideElements: [ArticleInside] = []
    private var article: Article? = nil
    private var sequence: Int? = nil
    private var articleTitle = ""
    private var parentID: String?
    
    func configure(with article: Article?, as sequence: Int, parentID: String?) {
        self.article = article
        self.sequence = sequence
        self.parentID = parentID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshUI()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(InsideCell.self, forCellReuseIdentifier: CellIdentifiers.insideCell.rawValue)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        
        let headerView = NewCharacteristicsArticleHeaderView()
        headerView.configure(with: article, as: self)
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame = CGRect(x: 0,
                                                  y: 0,
                                                  width: self.view.frame.width,
                                                  height: 62
                                                    )
        
        let previewBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(previewArticle(sender:)))
        
        previewBarButtonItem.isEnabled = self.article != nil
        
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveArticle(sender:)))
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addElement(sender:)))
        
        navigationItem.rightBarButtonItems = [addBarButtonItem, saveBarButtonItem, previewBarButtonItem]
    }
}

//MARK: - TableView DataSource
extension NewCharacteristicArticleTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleInsideElements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.insideCell.rawValue, for: indexPath) as! InsideCell
        
        let caption: String
        let typeText: String
        let element = articleInsideElements[indexPath.row]
        
        switch element.type {
        case .image:
            typeText = "Изображение"
            if let _caption = element.caption, _caption != "" {
                caption = "\(_caption.prefix(40))…"
            } else {
                caption = "…"
            }
        case .list:
            typeText = "Список"
            if let listElements = element.listElements, !listElements.isEmpty {
                caption = "\(listElements[0].prefix(40))…"
            } else {
                caption = "…"
            }
        case .text:
            typeText = "Текст"
            if let _caption = element.caption, _caption != "" {
                caption = "\(_caption.prefix(40))…"
            } else {
                if let _text = element.text, _text != "" {
                    caption = "\(_text.prefix(40))…"
                } else {
                    caption = "…"
                }
            }
        }
        
        cell.configure(with: caption, as: typeText)
        
        return cell
    }
}

//MARK: - TableView Delegate
extension NewCharacteristicArticleTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let elementToPass = articleInsideElements[indexPath.row]
        
        let viewController: ArticleInsideElementsProtocol
        switch elementToPass.type {
        case .image:
            viewController = NewImageInsideViewController()
        case .list:
            viewController = NewListInsideTableViewController()
        case .text:
            viewController = NewTextInsideViewController()
        }
        
        viewController.configure(with: elementToPass, as: indexPath.row, delegate: self)
        navigationController?.pushViewController(viewController as! UIViewController, animated: true)
    }
}

//MARK: - UI creation and refreshing
extension NewCharacteristicArticleTableViewController {
    private func refreshUI() {
        let footerText = "Для создания новой статьи укажите её заголовок и добавьте элементы статьи, такие как абзацы текста, изображения и списки, с помощью кнопки + в правом верхнем углу экрана."
        let actitivityIndicator = ActivityIndicator()
        actitivityIndicator.start()
        
        guard let article = self.article else {
            articleInsideElements = []
            tableView.tableFooterView = TableFooterView.shared.create(with: footerText, in: self.view, empty: true)
            actitivityIndicator.stop()
            return
        }
        
        FirebaseController.shared.getDataController().fetchArticle(with: article.id) {
            (result: Result<[ArticleInside]>) in
            
            actitivityIndicator.stop()
            switch result {
            case .success(let articleInsideArray):
                print("\(articleInsideArray)")
                self.articleInsideElements = articleInsideArray
                self.tableView.reloadData()
                let headerView = NewCharacteristicsArticleHeaderView()
                headerView.configure(with: article, as: self)
                self.articleTitle = article.title
                self.tableView.tableFooterView = TableFooterView.shared.create(with: footerText, in: self.view, empty: self.articleInsideElements.isEmpty)
            case .failure(let error):
                print("\(error.getError())")
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
}

//MARK: - Bar Button Items processing
extension NewCharacteristicArticleTableViewController {
    @objc
    private func previewArticle(sender: UIBarButtonItem) {
        print("preview button was tapped")
    }
    
    @objc
    private func saveArticle(sender: UIBarButtonItem) {
        saveArticle(completion: nil)
    }
    
    @objc
    private func editSequence(sender: UIBarButtonItem) {
        print("edit sequence button was tapped")
    }
    
    @objc
    private func addElement(sender: UIBarButtonItem) {
        let sequenceToPass: Int
        if articleInsideElements.isEmpty {
            sequenceToPass = 1
        } else {
            sequenceToPass = articleInsideElements.count + 1
        }
        
        let menuController = UIAlertController(title: nil, message: "Выберите тип добавляемого элемента статьи:", preferredStyle: UIAlertController.Style.actionSheet)
        
        let textElement = UIAlertAction(title: "Абзац текста", style: .default) {
            _ in
            let textVC = NewTextInsideViewController()
            textVC.configure(with: nil, as: sequenceToPass, delegate: self)
            self.navigationController?.pushViewController(textVC, animated: true)
        }
        
        let imageElement = UIAlertAction(title: "Изображение", style: .default) {
            _ in
            let imageVC = NewImageInsideViewController()
            imageVC.configure(with: nil, as: sequenceToPass, delegate: self)
            self.navigationController?.pushViewController(imageVC, animated: true)
        }
        
        let listElement = UIAlertAction(title: "Список", style: .default) {
            _ in
            let listVC = NewListInsideTableViewController()
            listVC.configure(with: nil, as: sequenceToPass, delegate: self)
            self.navigationController?.pushViewController(listVC, animated: true)
        }
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) {
            _ in
            print("No new element. Action is canceled")
        }
        
        menuController.addAction(textElement)
        menuController.addAction(imageElement)
        menuController.addAction(listElement)
        menuController.addAction(cancel)
        
        if let popoverController = menuController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        present(menuController, animated: true)
    }
}

// MARK: - Article Title Save Delegate
extension NewCharacteristicArticleTableViewController: ArticleTitleSaveProtocol {
    func saveArticleTitle(_ title: String) {
        self.articleTitle = title
    }
}

// MARK: - Article Save Delegate
extension NewCharacteristicArticleTableViewController: ArticleSaveDelegateProtocol {
    func saveArticle(articleInside: ArticleInside, with articleInsideID: String?) {
        saveArticle {
            (article: Article) in
            
            let activityIndicator = ActivityIndicator()
            activityIndicator.start()
            
            let articleInsideToSave = ArticleInside(id: articleInside.id,
                                                    parentID: article.id,
                                                    sequence: articleInside.sequence,
                                                    type: articleInside.type,
                                                    caption: articleInside.caption,
                                                    text: articleInside.text,
                                                    imageURL: articleInside.imageURL,
                                                    imageName: articleInside.imageName,
                                                    numericList: articleInside.numericList,
                                                    listElements: articleInside.listElements
            )
            
            FirebaseController.shared.getDataController().saveData(articleInsideToSave, with: articleInsideID, in: DBTables.articlesInside) {
                newResult in
                
                activityIndicator.stop()
                switch newResult {
                case .success(_):
                    self.refreshUI()
                case .failure(let error):
                    let alertDialog = AlertDialog(title: nil, message: error.getError())
                    alertDialog.showAlert(in: self, completion: nil)
                }
            }
        }
    }
    
    private func saveArticle(completion: ((Article) -> Void)?) {
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        let articleToSave: Article
        let id: String?
        
        guard
            let parentID = parentID,
            let sequence = sequence else {
                activityIndicator.stop()
                return
        }
        
        if article == nil {
            id = nil
            articleToSave = Article(id: "",
                                    title: self.articleTitle,
                                    parentID: parentID,
                                    parentType: DBTables.characteristics.rawValue,
                                    sequence: sequence,
                                    grants: 0, // To be amended
                                    authorID: "1", // To be amended
                                    rating: 0,
                                    verified: false
                                    )
        } else {
            id = article!.id
            articleToSave = Article(id: id!,
                                    title: self.articleTitle,
                                    parentID: parentID,
                                    parentType: article!.parentType,
                                    sequence: sequence,
                                    grants: article!.grants,
                                    authorID: article!.authorID,
                                    rating: article!.rating,
                                    verified: article!.verified
                                    )
        }
        
        FirebaseController.shared.getDataController().saveData(articleToSave, with: id, in: DBTables.articles) {
            result in
            
            activityIndicator.stop()
            switch result {
            case .success(let article):
                self.article = article
                guard let completion = completion else {
                    self.refreshUI()
                    return
                }
                
                completion(article)
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
}
