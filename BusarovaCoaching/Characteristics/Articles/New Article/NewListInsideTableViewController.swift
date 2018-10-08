//
//  NewListInsideTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

protocol ListCaptionSaveProtocol {
    func saveListCaption(_ caption: String)
}

class NewListInsideTableViewController: UITableViewController, ArticleInsideElementsProtocol {
    private var articleInside: ArticleInside?
    private var sequence: Int?
    private var articleSaveDelegate: ArticleSaveDelegateProtocol?
    
    private var articleInsideID: String?
    private var listCaption: String = ""
    
    lazy private var editTextElementsBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Изменить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editList(sender:)))
    }()
    
    lazy private var saveBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveList(sender:)))
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
    
    func configure(with articleInside: ArticleInside?, as sequence: Int, delegate: ArticleSaveDelegateProtocol) {
        self.articleInside = articleInside
        self.sequence = sequence
        self.articleSaveDelegate = delegate
        
        self.articleInsideID = articleInside?.id
        listCaption = articleInside?.caption ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = true
        
        tableView.register(ListElementsCell.self, forCellReuseIdentifier: CellIdentifiers.listElementCell.rawValue)
        
        let headerView = NewListInsideHeaderView()
        headerView.configure(with: articleInside?.caption ?? "", as: self)
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame = CGRect(x: 0,
                                                  y: 0,
                                                  width: self.view.frame.width,
                                                  height: 70
                                                    )
        
        editButtonItem.title = "Настроить"
        
        navigationItem.rightBarButtonItems = [editButtonItem, saveBarButtonItem, editTextElementsBarButtonItem]
        saveBarButtonItem.isEnabled = !isSaved
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: nil)
        
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
extension NewListInsideTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articleInside == nil {
            return 0
        } else {
            return articleInside!.listElements!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.listElementCell.rawValue, for: indexPath) as! ListElementsCell
        
        guard let elementToPass = articleInside else {
            return cell
        }
        
        let bulletSign = elementToPass.numericList! ? "\(indexPath.row + 1)" : LiteralConsts.nonNumericListBullet.rawValue
        
        cell.configure(with: elementToPass.listElements![indexPath.row], bullet: bulletSign)
        
        return cell
    }
}

// MARK: - TableView Delegate
extension NewListInsideTableViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = UIColor.white
        
        let listTypeControl: UISegmentedControl = {
            let control = UISegmentedControl()
    
            control.translatesAutoresizingMaskIntoConstraints = false
            control.insertSegment(withTitle: "Нумерованный", at: 0, animated: false)
            control.insertSegment(withTitle: "Обычный", at: 1, animated: false)
            control.addTarget(self, action: #selector(segmentedControlDidChanged(sender:)), for: UIControl.Event.valueChanged)
    
            return control
        }()
        
        view.addSubview(listTypeControl)

        NSLayoutConstraint.activate([
            listTypeControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listTypeControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            view.bottomAnchor.constraint(equalTo: listTypeControl.bottomAnchor, constant: 8)
            ])
        
        if articleInside == nil {
            listTypeControl.selectedSegmentIndex = 0
        } else {
            listTypeControl.selectedSegmentIndex = articleInside!.numericList! ? 0 : 1
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard
            let articleInside = articleInside,
            var listElements = articleInside.listElements else {
                return
        }
        
        let elementToMove = listElements[sourceIndexPath.row]
        
        listElements.remove(at: sourceIndexPath.row)
        listElements.insert(elementToMove, at: destinationIndexPath.row)
        self.articleInside = create(as: nil, elements: listElements)
        isSaved = false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard
                let articleInside = articleInside,
                var listElements = articleInside.listElements else {
                return
            }
            
            listElements.remove(at: indexPath.row)
            self.articleInside = create(as: nil, elements: listElements)
            tableView.deleteRows(at: [indexPath], with: .fade)
            isSaved = false
        }
    }
}

extension NewListInsideTableViewController {
    @objc
    private func segmentedControlDidChanged(sender: UISegmentedControl) {
        isSaved = false
        let numericList = sender.selectedSegmentIndex == 0 ? true : false
        
        articleInside = create(as: numericList, elements: nil)
        
        refreshUI()
    }
    
    @objc
    private func editList(sender: UIBarButtonItem) {
        if articleInside == nil {
            articleInside = create(as: true, elements: nil)
        }
        
        let editVC = EditListInsideViewController()
        editVC.configure(with: articleInside!, delegate: self)
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc
    private func saveList(sender: UIBarButtonItem) {
        saveList(withLeaving: true)
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        }
    }
    
    private func refreshUI() {
        listCaption = articleInside?.caption ?? ""
        tableView.reloadData()
        if let listElements = articleInside?.listElements {
            editButtonItem.isEnabled = !listElements.isEmpty
        } else {
            editButtonItem.isEnabled = false
        }
    }
    
    private func create(as numeric: Bool?, elements: [String]?) -> ArticleInside? {
        guard let sequence = sequence else {
            return nil
        }
        
        let listElements = elements ?? articleInside?.listElements ?? []
        
        let result = ArticleInside(id: articleInside?.id ?? "",
                                   parentID: articleInside?.parentID ?? "",
                                   sequence: sequence,
                                   type: .list,
                                   caption: listCaption,
                                   text: nil,
                                   imageURL: nil,
                                   imageName: nil,
                                   numericList: numeric ?? articleInside?.numericList ?? true,
                                   listElements: listElements
                                    )
        
        return result
    }
    
    private func saveList(withLeaving: Bool) {
        guard let elementToSave = create(as: nil, elements: nil) else {
            return
        }
        
        articleSaveDelegate?.saveArticle(articleInside: elementToSave, with: articleInsideID)
        if withLeaving {
            navigationController?.popViewController(animated: true)
        } else {
            isSaved = true
        }
    }
}

// MARK: - SaveListElementsProtocol
extension NewListInsideTableViewController: SaveListElementsProtocol {
    func saveListElements(_ elements: [String]) {
        articleInside = create(as: nil, elements: elements)
        refreshUI()
        saveList(withLeaving: false)
    }
}

// MARK: - ListCaptionSaveProtocol
extension NewListInsideTableViewController: ListCaptionSaveProtocol {
    func saveListCaption(_ caption: String) {
        if caption != self.listCaption {
            self.listCaption = caption
            isSaved = false
        }
    }
}
