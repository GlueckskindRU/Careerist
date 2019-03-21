//
//  ArticleNoteViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 18/03/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class ArticleNoteViewController: UIViewController {
    private var articleID: String?
    private var articleTitle: String?
    private var currentUser: User? = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser()
    private var activityIndicator = ActivityIndicator()
    private var articleNotes: ArticleNotes?
    private var originalText: String = ""
    private var showArticlePossibility: Bool = false
    private var article: Article?
    
    let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    var receivedArticlePushes: [CDReceivedArticles] = []
    
    lazy private var saveNoteButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveNoteButtonTapped(_:)))
    }()
    
    lazy private var deleteNoteButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(deleteNoteButtonTapped(_:)))
    }()
    
    lazy private var customBackBarButton: UIBarButtonItem = {
        let backArrow = UIImage(named: Assets.backArrow.rawValue)
        return UIBarButtonItem(image: backArrow, style: UIBarButtonItem.Style.plain, target: self, action: #selector(back(_:)))
    }()
    
    lazy private var noteTextView: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.delegate = self
        
        return textView
    }()
    
    lazy private var showArticleButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Просмотреть статью", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(showArticleButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private var isSaved: Bool = true {
        didSet {
            saveNoteButton.isEnabled = !isSaved
        }
    }
    
    func configure(with articleID: String, title: String, showArticle: Bool) {
        self.articleID = articleID
        self.articleTitle = title
        self.showArticlePossibility = showArticle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard
            let articleID = articleID,
            let articleTitle = articleTitle,
            let currentUser = currentUser else {
                return
        }
        
        let sortDescriptor = NSSortDescriptor(key: "receivedTime", ascending: false)
        receivedArticlePushes = coreDataManager.fetchData(for: CDReceivedArticles.self, predicate: nil, sortDescriptor: sortDescriptor)
        
        fetchNote(for: currentUser, with: articleID)
        navigationItem.title = articleTitle
        navigationItem.rightBarButtonItems = [saveNoteButton, deleteNoteButton]
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = customBackBarButton
        
        saveNoteButton.isEnabled = !isSaved
        setupLayout()
    }
}

// MARK: - Auxiliaries functions
extension ArticleNoteViewController {
    private func setupLayout() {
        view.addSubview(noteTextView)
        view.addSubview(showArticleButton)
        
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            noteTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: noteTextView.trailingAnchor, constant: 16),
            
            showArticleButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 16),
            showArticleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: showArticleButton.trailingAnchor, constant: 16),
            showArticleButton.heightAnchor.constraint(equalToConstant: 48),
            ])
        
        noteTextView.becomeFirstResponder()
    }
    
    private func fetchNote(for currentUser: User, with articleID: String) {
        activityIndicator.start()
        fetchArticle(with: articleID)
        
        FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.articleNotes) {
            (result: Result<ArticleNotes>) in
            
            self.activityIndicator.stop()
            
            switch result {
            case .success(let notes):
                self.articleNotes = notes
                guard let notesData = notes.notes[articleID] else {
                    return
                }
                print("notes = \(notes)")
                self.noteTextView.text = notesData["note"]
                self.originalText = notesData["note"] ?? ""
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
    
    private func fetchArticle(with articleID: String) {
        FirebaseController.shared.getDataController().fetchData(with: articleID, from: DBTables.articles) {
            (result: Result<Article>) in
            
            if let article = result.value {
                self.showArticleButton.isHidden = false
                self.showArticleButton.isEnabled = true
                
                self.article = article
            } else {
                self.showArticleButton.isHidden = true
                self.showArticleButton.isEnabled = false
            }
        }
    }
    
    private func saveNote(_ articleNote: ArticleNotes, with id: String, quitingCompletion: optionalVoid) {
        activityIndicator.start()
        
        FirebaseController.shared.getDataController().saveData(articleNote, with: id, in: DBTables.articleNotes) {
            (result: Result<ArticleNotes>) in
            
            self.activityIndicator.stop()
            
            switch result {
            case .success(let storedValue):
                self.articleNotes = storedValue
                self.isSaved = true
                if let quitingCompletion = quitingCompletion {
                    quitingCompletion()
                }
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
    
    private func showQuitingAlertDialog(quitingCompletion: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: "Сохранить изменения?", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "Да", style: UIAlertAction.Style.default) {
            _ in
            self.updateNote(quitingCompletion: quitingCompletion)
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
    
    private func showDeletionDialog(title: String, quitingCompletion: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: "Удалить заметку к статье \"\(title)\"?", preferredStyle: UIAlertController.Style.alert)
        
        let deletAction = UIAlertAction(title: "Да", style: UIAlertAction.Style.default) {
            _ in
            self.deleteCurrentNote(quitingCompletion: quitingCompletion)
        }
        
        let cancelAction = UIAlertAction(title: "Нет", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(deletAction)
        alertController.addAction(cancelAction)
        alertController.preferredAction = cancelAction
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateNote(quitingCompletion: optionalVoid) {
        guard
            let articleID = articleID,
            let currentUser = currentUser,
            var articleNotes = articleNotes,
            let articleTitle = articleTitle,
            let noteText = noteTextView.text else {
                isSaved = false
                return
        }
        
        articleNotes.notes[articleID] = ["note": noteText, "title": articleTitle]
        saveNote(articleNotes, with: currentUser.id, quitingCompletion: quitingCompletion)
    }
    
    private func deleteCurrentNote(quitingCompletion: optionalVoid) {
        guard
            let articleID = articleID,
            let currentUser = currentUser,
            var articleNotes = articleNotes else {
                isSaved = false
                return
        }
        
        if let _ = articleNotes.notes.removeValue(forKey: articleID) {
            saveNote(articleNotes, with: currentUser.id, quitingCompletion: quitingCompletion)
        }
    }
    
    private func getArticlePushQuestionsStatus(for id: String) -> Bool {
        for push in receivedArticlePushes {
            if let receivedID = push.id {
                if receivedID == id {
                    return push.hasQuestions
                }
            }
        }
        
        return false
    }
}

// MARK: - OBJC functions
extension ArticleNoteViewController {
    @objc
    private func saveNoteButtonTapped(_ sender: UIBarButtonItem) {
        updateNote(quitingCompletion: nil)
    }
    
    @objc
    private func back(_ sender: UIBarButtonItem) {
        if isSaved {
            _ = navigationController?.popViewController(animated: true)
        } else {
            showQuitingAlertDialog {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc
    private func showArticleButtonTapped(_ sender: UIButton) {
        guard let article = article else {
            return
        }
        
        let articleVC = ArticlesPreviewTableViewController()
        articleVC.configure(with: article, hasQuestions: getArticlePushQuestionsStatus(for: article.id))
        
        navigationController?.pushViewController(articleVC, animated: true)
    }
    
    @objc
    private func deleteNoteButtonTapped(_ sende: UIBarButtonItem) {
        guard let articleTitle = articleTitle else {
            return
        }
        
        showDeletionDialog(title: articleTitle) {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITextView Delegate
extension ArticleNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        isSaved = textView.text == originalText
    }
}
