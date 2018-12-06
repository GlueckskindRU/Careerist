//
//  ArticlesPreviewTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 19/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ArticlesPreviewTableViewController: UITableViewController {
    private var article: Article?
    private var articlesElements: [ArticleInsideUnwrapped] = []
    
    func configure(with article: Article) {
        self.article = article
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ArticleTextCell.self, forCellReuseIdentifier: CellIdentifiers.articleTextCell.rawValue)
        tableView.register(ArticleTextWithCaptionCell.self, forCellReuseIdentifier: CellIdentifiers.articleTextWithCaptionCell.rawValue)
        tableView.register(ArticleImageCell.self, forCellReuseIdentifier: CellIdentifiers.articleImageCell.rawValue)
        tableView.register(ArticleImageWithCaptionCell.self, forCellReuseIdentifier: CellIdentifiers.articleImageWithCaptionCell.rawValue)
        tableView.register(ArticleListCell.self, forCellReuseIdentifier: CellIdentifiers.articleListCell.rawValue)
        tableView.register(ArticleListWithCaptionCell.self, forCellReuseIdentifier: CellIdentifiers.articleListWithCaptionCell.rawValue)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        let headerView = ArticlesPreviewHeaderView()
        headerView.configure(with: article?.title)
        tableView.setAndLayoutTableHeaderView(header: headerView)
        
        refreshUI()
    }
}

// MARK: - TableView DataSource
extension ArticlesPreviewTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesElements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        let elementToPass = articlesElements[indexPath.row]
        
        guard let type = elementToPass.type else {
            return UITableViewCell()
        }
        
        switch type {
        case .image:
            if elementToPass.caption == nil {
                let originalCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.articleImageCell.rawValue, for: indexPath) as! ArticleImageCell
                originalCell.configure(with: elementToPass.image!)
                cell = originalCell as UITableViewCell
            } else {
                let originalCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.articleImageWithCaptionCell.rawValue, for: indexPath) as! ArticleImageWithCaptionCell
                originalCell.configure(with: elementToPass.image!, caption: elementToPass.caption!)
                cell = originalCell as UITableViewCell
            }
        case .list:
            if elementToPass.caption == nil {
                let originalCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.articleListCell.rawValue, for: indexPath) as! ArticleListCell
                originalCell.configure(with: elementToPass.listElements!)
                cell = originalCell as UITableViewCell
            } else {
                let originalCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.articleListWithCaptionCell.rawValue, for: indexPath) as! ArticleListWithCaptionCell
                originalCell.configure(with: elementToPass.caption!, listText: elementToPass.listElements!)
                cell = originalCell as UITableViewCell
            }
        case .text:
            if elementToPass.caption == nil {
                let originalCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.articleTextCell.rawValue, for: indexPath) as! ArticleTextCell
                originalCell.configure(with: elementToPass.text!)
                cell = originalCell as UITableViewCell
            } else {
                let originalCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.articleTextWithCaptionCell.rawValue, for: indexPath) as! ArticleTextWithCaptionCell
                originalCell.configure(with: elementToPass.caption!, text: elementToPass.text!)
                cell = originalCell as UITableViewCell
            }
        case .testQuestion:
            //should never been happend
            cell = UITableViewCell()
        }
        
        return cell
    }
}

// MARK: - auxiliary functions
extension ArticlesPreviewTableViewController {
    private func refreshUI() {
        guard let article = article else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        FirebaseController.shared.getDataController().fetchArticle(with: article.id, forPreview: true) {
            (result: Result<[ArticleInside]>) in
            
            activityIndicator.stop()
            switch result {
            case .success(let articleInsideArray):
                let defaultElement = ArticleInsideUnwrapped(type: nil,
                                                            caption: nil,
                                                            text: nil,
                                                            image: nil,
                                                            listElements: nil
                                                            )
                self.articlesElements = Array(repeating: defaultElement, count: articleInsideArray.count)
                for index in articleInsideArray.indices {
                    switch articleInsideArray[index].type {
                    case .image:
                        self.unwrapImage(articleInsideArray[index]) {
                            (result: Result<ArticleInsideUnwrapped>) in
                            
                            switch result {
                            case .success(let imageElementUnwrapped):
                                self.articlesElements[index] = imageElementUnwrapped
                                self.tableView.reloadData()
                            case .failure(let error):
                                let alertDialog = AlertDialog(title: nil, message: error.getError())
                                alertDialog.showAlert(in: self, completion: nil)
                            }
                        }
                    case .list:
                        if let elementUnwrapped = self.unwrapList(articleInsideArray[index]) {
                            self.articlesElements[index] = elementUnwrapped
                        }
                    case .text:
                        if let elementUnwrapped = self.unwrapText(articleInsideArray[index]) {
                            self.articlesElements[index] = elementUnwrapped
                        }
                    case .testQuestion:
                        continue
                    }
                }
                self.tableView.reloadData()
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
    
    private func unwrapText(_ articleInside: ArticleInside) -> ArticleInsideUnwrapped? {
        guard let text = articleInside.text else {
            return nil
        }
        
        let caption: String?
        if articleInside.caption == nil {
            caption = nil
        } else {
            caption = articleInside.caption!
        }
        
        let result = ArticleInsideUnwrapped(type: ArticleInsideType.text,
                                            caption: caption,
                                            text: text,
                                            image: nil,
                                            listElements: nil
                                            )
        
        return result
    }

    private func unwrapImage(_ articleInside: ArticleInside, completion: @escaping (Result<ArticleInsideUnwrapped>) -> Void) {
        guard let imageStorageURL = articleInside.imageStorageURL else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        let caption: String?
        if articleInside.caption == nil {
            caption = nil
        } else {
            caption = articleInside.caption!
        }
        
        FirebaseController.shared.getStorageController().downloadImage(with: imageStorageURL) {
            (result: Result<UIImage>) in
            
            activityIndicator.stop()
            switch result {
            case .success(let image):
                let result = ArticleInsideUnwrapped(type: ArticleInsideType.image,
                                                    caption: caption,
                                                    text: nil,
                                                    image: image,
                                                    listElements: nil
                                                    )
                completion(Result.success(result))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    private func unwrapList(_ articleInside: ArticleInside) -> ArticleInsideUnwrapped? {
        guard
            let listElements = articleInside.listElements,
            let isNumeric = articleInside.numericList else {
                return nil
        }
        
        let caption: String?
        if articleInside.caption == nil {
            caption = nil
        } else {
            caption = articleInside.caption!
        }
        
        var text: String = ""
        
        func getString(_ index: Int) -> String {
            return isNumeric ? "\(index + 1). \(listElements[index])" : "\(LiteralConsts.nonNumericListBullet.rawValue) \(listElements[index])"
        }
        
        for index in listElements.indices {
            if index == 0 {
                text += getString(index)
            } else {
                text += "\n"
                text += getString(index)
            }
        }
        
        let result = ArticleInsideUnwrapped(type: ArticleInsideType.list,
                                            caption: caption,
                                            text: nil,
                                            image: nil,
                                            listElements: text
                                            )
        
        return result
    }
}
