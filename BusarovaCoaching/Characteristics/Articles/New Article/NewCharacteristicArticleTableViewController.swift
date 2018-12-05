//
//  NewCharacteristicArticleTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 12/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

protocol ArticleSaveDelegateProtocol {
    func saveArticle(articleInside: UIArticleInside, with articleInsideID: String?)
}

protocol ArticleTitleSaveProtocol {
    func saveArticleTitle(_ title: String)
}

protocol ArticleInsideElementsProtocol {
    func configure(with articleInside: UIArticleInside?, as sequence: Int, delegate: ArticleSaveDelegateProtocol)
}

// MARK: - class definition
class NewCharacteristicArticleTableViewController: UITableViewController {
    private var articleInsideElements: [UIArticleInside] = []
    private var article: Article? = nil
    private var sequence: Int? = nil
    private var articleTitle = ""
    private var parentID: String?
    private var deletedElements: Set<UIArticleInside> = []
    private var isOffline: Bool = (UIApplication.shared.delegate as! AppDelegate).appManager.isOffline
    private let dataService = DataService()
    
    lazy private var saveBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveArticle(sender:)))
    }()
    
    lazy private var previewBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(previewArticle(sender:)))
    }()
    
    lazy private var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addElement(sender:)))
    }()
    
    private var isSaved: Bool = true {
        didSet {
            if isSaved {
                saveBarButtonItem.isEnabled = false
            } else {
                if self.isEditing {
                    saveBarButtonItem.isEnabled = false
                } else {
                    saveBarButtonItem.isEnabled = true && !isOffline
                }
            }
        }
    }
    
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
        
        previewBarButtonItem.isEnabled = (self.article != nil) && !isOffline
        saveBarButtonItem.isEnabled = !isSaved && !isOffline
        
        editButtonItem.title = "Настроить"
        navigationItem.rightBarButtonItems = [editButtonItem, addBarButtonItem, saveBarButtonItem, previewBarButtonItem]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            editButtonItem.title = "Завершить"
        } else {
            editButtonItem.title = "Настроить"
            if !isSaved {
                saveBarButtonItem.isEnabled = true && !isOffline
            }
        }
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
                caption = "\(_caption.prefix(40))\(LiteralConsts.dots.rawValue)"
            } else {
                caption = "\(LiteralConsts.dots.rawValue)"
            }
        case .list:
            typeText = "Список"
            if let _caption = element.caption, _caption != "" {
                caption = "\(_caption.prefix(40))\(LiteralConsts.dots.rawValue)"
            } else {
                if let listElements = element.listElements, !listElements.isEmpty {
                    caption = "\(listElements[0].prefix(40))\(LiteralConsts.dots.rawValue)"
                } else {
                    caption = "\(LiteralConsts.dots.rawValue)"
                }
            }
        case .text:
            typeText = "Текст"
            if let _caption = element.caption, _caption != "" {
                caption = "\(_caption.prefix(40))\(LiteralConsts.dots.rawValue)"
            } else {
                if let _text = element.text, _text != "" {
                    caption = "\(_text.prefix(40))\(LiteralConsts.dots.rawValue)"
                } else {
                    caption = "\(LiteralConsts.dots.rawValue)"
                }
            }
        case .testQuestion:
            typeText = "Тестовый вопрос"
            if let _text = element.text, _text != "" {
                caption = "\(_text.prefix(40))\(LiteralConsts.dots.rawValue)"
            } else {
                caption = "\(LiteralConsts.dots.rawValue)"
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
        case .testQuestion:
            viewController = NewTestQuestionTableViewController()
        }
        
        viewController.configure(with: elementToPass, as: indexPath.row, delegate: self)
        navigationController?.pushViewController(viewController as! UIViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard !articleInsideElements.isEmpty else {
            return
        }
            
        let elementToMove = articleInsideElements[sourceIndexPath.row]
        
        articleInsideElements.remove(at: sourceIndexPath.row)
        articleInsideElements.insert(elementToMove, at: destinationIndexPath.row)
        reorderSequences()
        isSaved = false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard !articleInsideElements.isEmpty else {
                return
            }
            
            deletedElements.insert(articleInsideElements[indexPath.row])
            
            articleInsideElements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            reorderSequences()
            isSaved = false
        }
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
            self.editButtonItem.isEnabled = !self.articleInsideElements.isEmpty
            actitivityIndicator.stop()
            return
        }
        
        dataService.fetchArticle(with: article.id, forPreview: false) {
            (result: Result<[UIArticleInside]>) in
            
            actitivityIndicator.stop()
            switch result {
            case .success(let articleInsideArray):
                self.articleInsideElements = articleInsideArray
                self.tableView.reloadData()
                let headerView = NewCharacteristicsArticleHeaderView()
                headerView.configure(with: article, as: self)
                self.articleTitle = article.title
                self.tableView.tableFooterView = TableFooterView.shared.create(with: footerText, in: self.view, empty: self.articleInsideElements.isEmpty)
                self.editButtonItem.isEnabled = !self.articleInsideElements.isEmpty
            case .failure(let error):
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
        guard let article = article else {
            return
        }
        
        let previewVC = ArticlesPreviewTableViewController()
        previewVC.configure(with: article)
        navigationController?.pushViewController(previewVC, animated: true)
    }
    
    @objc
    private func saveArticle(sender: UIBarButtonItem) {
        deleteArtileInsides()
        saveArticleInsides()
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        }
    }
    
    @objc
    private func addElement(sender: UIBarButtonItem) {
        let sequenceToPass = articleInsideElements.isEmpty ? 0 : articleInsideElements.count
        
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
        
        let testQuestionElement = UIAlertAction(title: "Тестовый вопрос", style: .default) {
            _ in
            let testQuestionVC = NewTestQuestionTableViewController()
            testQuestionVC.configure(with: nil, as: sequenceToPass, delegate: self)
            self.navigationController?.pushViewController(testQuestionVC, animated: true)
        }
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) {
            _ in
            print("No new element. Action is canceled")
        }
        
        menuController.addAction(textElement)
        menuController.addAction(imageElement)
        menuController.addAction(listElement)
        menuController.addAction(testQuestionElement)
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
    func saveArticle(articleInside: UIArticleInside, with articleInsideID: String?) {
        saveArticle {
            (article: Article) in
            
            let activityIndicator = ActivityIndicator()
            activityIndicator.start()
            
            let articleInsideToSave = UIArticleInside(id: articleInside.id,
                                                      parentID: article.id,
                                                      sequence: articleInside.sequence,
                                                      type: articleInside.type,
                                                      caption: articleInside.caption,
                                                      text: articleInside.text,
                                                      image: articleInside.image,
                                                      imageURL: articleInside.imageURL,
                                                      imageStorageURL: articleInside.imageStorageURL,
                                                      imageName: articleInside.imageName,
                                                      numericList: articleInside.numeringList,
                                                      listElements: articleInside.listElements
                                                        )
            
            self.dataService.saveArticleInside(articleInsideToSave, with: articleInsideID) {
                (newResult: Result<UIArticleInside>) in
                
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
}

// MARK: - auxiliaries functions
extension NewCharacteristicArticleTableViewController {
    private func saveArticleInsides() {
        guard !articleInsideElements.isEmpty else {
            return
        }
        
        saveArticle {
            (article: Article) in
            
            let activityIndicator = ActivityIndicator()
            for element in self.articleInsideElements {
                activityIndicator.start()
                
                self.dataService.saveArticleInside(element, with: element.id) {
                    (result: Result<UIArticleInside>) in
                    
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
    
    private func saveArticle(completion: ((Article) -> Void)?) {
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        let articleToSave: Article
        let id: String?
        
        guard
            let parentID = parentID,
            let sequence = sequence,
            let currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser() else {
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
                                    authorID: currentUser.id,
                                    rating: 0,
                                    verified: false,
                                    type: ArticleType.article
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
                                    verified: article!.verified,
                                    type: ArticleType.article
                                    )
        }
        
        dataService.saveArticle(articleToSave, with: id) {
            (result: Result<Article>) in
            
            activityIndicator.stop()
            switch result {
            case .success(let article):
                self.article = article
                guard let completion = completion else {
                    self.isSaved = true
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
    
    private func deleteArtileInsides() {
        guard !deletedElements.isEmpty else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        for element in deletedElements {
            activityIndicator.start()
            
            dataService.deleteArticleInside(with: element.id) {
                (result: Result<Bool>) in
                
                activityIndicator.stop()
                switch result {
                case .success(_):
                    guard
                        self.deletedElements.contains(element),
                        let _ = self.deletedElements.remove(element) else {
                            return
                    }
                    
                    self.isSaved = true
                case .failure(let error):
                    let alertDialog = AlertDialog(title: nil, message: error.getError())
                    alertDialog.showAlert(in: self, completion: nil)
                }
            }
        }
    }

    private func reorderSequences() {
        guard !articleInsideElements.isEmpty else {
            return
        }
        
        for index in articleInsideElements.indices {
            articleInsideElements[index].sequence = index
        }
    }
}
