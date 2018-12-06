//
//  NewTestQuestionTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 01/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

protocol TestQuestionSaveProtocol {
    func saveTestQuestion(_ question: String)
}

class NewTestQuestionTableViewController: UITableViewController, ArticleInsideElementsProtocol {
    private let separator: Character = "|"
    
    private var articleInside: ArticleInside?
    private var sequence: Int?
    private var articleSaveDelegate: ArticleSaveDelegateProtocol?
    
    private var articleInsideID: String?
    private var testQuestion: String = ""
    
    lazy private var editAnswersBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(editAnswers(sender:)))
    }()
    
    lazy private var saveAnswersBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveAnswers(sender:)))
    }()
    
    private var isSaved: Bool = true {
        didSet {
            if isSaved {
                saveAnswersBarButtonItem.isEnabled = false
            } else {
                if self.isEditing {
                    saveAnswersBarButtonItem.isEnabled = false
                } else {
                    saveAnswersBarButtonItem.isEnabled = true
                }
            }
        }
    }
    
    func configure(with articleInside: ArticleInside?, as sequence: Int, delegate: ArticleSaveDelegateProtocol) {
        self.articleInside = articleInside
        self.sequence = sequence
        self.articleSaveDelegate = delegate
        
        self.articleInsideID = articleInside?.id
        testQuestion = articleInside?.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewTestQuestionCell.self, forCellReuseIdentifier: CellIdentifiers.articleTestAnswersCell.rawValue)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = true
        
        let headerView = NewTestQuestionHederView()
        headerView.configure(with: articleInside?.text ?? "", as: self)
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame = CGRect(x: 0,
                                                  y: 0,
                                                  width: self.view.frame.width,
                                                  height: 120
                                                )
        
        editButtonItem.title = "Настроить"
        navigationItem.rightBarButtonItems = [editButtonItem, saveAnswersBarButtonItem, editAnswersBarButtonItem]
        saveAnswersBarButtonItem.isEnabled = !isSaved
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            editButtonItem.title = "Завершить"
        } else {
            editButtonItem.title = "Настроить"
            if !isSaved {
                saveAnswersBarButtonItem.isEnabled = true
            }
        }
    }
}

// MARK: - TableView DataSource
extension NewTestQuestionTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articleInside == nil {
            return 0
        } else {
            return articleInside!.listElements!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.articleTestAnswersCell.rawValue, for: indexPath) as! NewTestQuestionCell
        
        guard
            let elementToPass = articleInside,
            let answer = elementToPass.listElements?[indexPath.row] else {
            return cell
        }
        
        cell.configure(number: "\(indexPath.row + 1)", answer: answer, isCorrectAnswer: isMarked(at: indexPath))
        
        return cell
    }
}

// MARK: - TableView Delegate
extension NewTestQuestionTableViewController {
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard
            let articleInside = articleInside,
            var answersList = articleInside.listElements else {
                return
        }
        
        let answerToMove = answersList[sourceIndexPath.row]
        
        answersList.remove(at: sourceIndexPath.row)
        answersList.insert(answerToMove, at: destinationIndexPath.row)
        self.articleInside = create(correctAnswer: nil, answers: answersList)
        isSaved = false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAnswer(at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") {
            deleteAction, indexPath in
            
            self.deleteAnswer(at: indexPath)
        }
        deleteAction.backgroundColor = .red
        
        let title = isMarked(at: indexPath) ? "Снять маркировку" : "Маркировать как правильный"
        
        let markAction = UITableViewRowAction(style: .normal, title: title) {
            markAction, indexPath in
            
            self.changeCorrectAnswer(at: indexPath, forInsertion: !self.isMarked(at: indexPath))
            
            self.tableView.reloadData()
            self.isSaved = false
        }
        markAction.backgroundColor = UIColor.blue
        
        return [deleteAction, markAction]
    }
}

// MARK: - auxiliaries functions
extension NewTestQuestionTableViewController {
    private func refreshUI() {
        testQuestion = articleInside?.text ?? ""
        tableView.reloadData()
        if let answersList = articleInside?.listElements {
            editButtonItem.isEnabled = !answersList.isEmpty
        } else {
            editButtonItem.isEnabled = false
        }
    }
    
    @objc
    private func editAnswers(sender: UIBarButtonItem) {
        if articleInside == nil {
            articleInside = create(correctAnswer: nil, answers: nil)
        }
        
        let editVC = EditListInsideViewController()
        editVC.configure(with: articleInside!, delegate: self)
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc
    private func saveAnswers(sender: UIBarButtonItem) {
        saveQuestion(withLeaving: true)
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        }
    }
    
    private func deleteAnswer(at indexPath: IndexPath) {
        guard
            let articleInside = articleInside,
            var answersList = articleInside.listElements else {
                return
        }
        
        answersList.remove(at: indexPath.row)
        self.articleInside = create(correctAnswer: nil, answers: answersList)
        tableView.deleteRows(at: [indexPath], with: .fade)
        isSaved = false
    }
    
    private func create(correctAnswer: String?, answers: [String]?) -> ArticleInside? {
        guard let sequence = sequence else {
            return nil
        }
        
        let answersList = answers ?? articleInside?.listElements ?? []

        let result = ArticleInside(id: articleInside?.id ?? "",
                                   parentID: articleInside?.parentID ?? "",
                                   sequence: sequence,
                                   type: ArticleInsideType.testQuestion,
                                   caption: correctAnswer ?? articleInside?.caption,
                                   text: testQuestion,
                                   imageStorageURL: nil,
                                   imageName: nil,
                                   numericList: nil,
                                   listElements: answersList
                                    )
        
        return result
    }
    
    private func saveQuestion(withLeaving: Bool) {
        guard let elementToSave = create(correctAnswer: nil, answers: nil) else {
            return
        }
        
        articleSaveDelegate?.saveArticle(articleInside: elementToSave, with: articleInsideID)
        if withLeaving {
            navigationController?.popViewController(animated: true)
        } else {
            isSaved = true
        }
    }
    
    private func isMarked(at indexPath: IndexPath) -> Bool {
        guard
            let articleInside = articleInside,
            let correctAnswers = articleInside.caption else {
            return false
        }
        let correctAnswersSet = Set(correctAnswers.split(separator: separator).map { "\($0)" } )
        
        return correctAnswersSet.contains("\(indexPath.row)")
    }
    
    private func changeCorrectAnswer(at indexPath: IndexPath, forInsertion: Bool) {
        var currentCorrectAnswers = articleInside?.caption ?? ""
        
        var correctAnswersSet = Set(currentCorrectAnswers.split(separator: separator).map { "\($0)" } )
        
        if forInsertion {
            if !isMarked(at: indexPath) {
               correctAnswersSet.insert("\(indexPath.row)")
            }
        } else {
            if isMarked(at: indexPath) {
                correctAnswersSet.remove("\(indexPath.row)")
            }
        }
        
        currentCorrectAnswers = correctAnswersSet.joined(separator: "\(separator)")
        
        articleInside = create(correctAnswer: currentCorrectAnswers, answers: nil)
    }
}

// MARK: - SaveListElementsProtocol
extension NewTestQuestionTableViewController: SaveListElementsProtocol {
    func saveListElements(_ elements: [String]) {
        articleInside = create(correctAnswer: nil, answers: elements)
        refreshUI()
        saveQuestion(withLeaving: false)
    }
}

// MARK: - TestQuestionSaveProtocol
extension NewTestQuestionTableViewController: TestQuestionSaveProtocol {
    func saveTestQuestion(_ question: String) {
        if question != self.testQuestion {
            self.testQuestion = question
            isSaved = false
        }
    }
}
