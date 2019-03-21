//
//  NotesTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 20/03/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    private var notesData: [String : [String: String]] = [:]
    private var articleIDsArray: [String] = []
    
    private var activityIndicator = ActivityIndicator()
    
    lazy private var logInBarButtonItem: UIBarButtonItem = {
        let icon = UIImage(named: Assets.login.rawValue)
        return UIBarButtonItem(image: icon, style: UIBarButtonItem.Style.plain, target: self, action: #selector(logInTapped(sender:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(NotesCell.self, forCellReuseIdentifier: CellIdentifiers.notesCell.rawValue)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        navigationItem.title = "Заметки к статьям"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (UIApplication.shared.delegate as! AppDelegate).appManager.isAuhorized() {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = logInBarButtonItem
        }
        
        fetchNotes()
    }
    
    @objc
    private func logInTapped(sender: UIBarButtonItem) {
        let authVC = AuthorizationViewController()
        authVC.configure()
        navigationController?.pushViewController(authVC, animated: true)
    }
}

// MARK: - UITableView DataSource
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleIDsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.notesCell.rawValue, for: indexPath) as? NotesCell,
            let data = notesData[articleIDsArray[indexPath.row]],
            let articleTitle = data["title"] else {
            return UITableViewCell()
        }
        
        cell.configure(with: articleTitle)
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleID = articleIDsArray[indexPath.row]
        
        guard
            let data = notesData[articleID],
            let articleTitle = data["title"] else {
                return
        }
        
        let destinationVC = ArticleNoteViewController()
        destinationVC.configure(with: articleID, title: articleTitle, showArticle: true)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - Fetching functions
extension NotesTableViewController {
    private func fetchNotes() {
        guard let currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser() else {
            return indicateNoUser()
        }
        
        activityIndicator.start()
        
        FirebaseController.shared.getDataController().fetchData(with: currentUser.id, from: DBTables.articleNotes) {
            (result: Result<ArticleNotes>) in
            
            self.activityIndicator.stop()
            
            switch result {
            case .success(let notes):
                guard !notes.notes.isEmpty else {
                    return self.indicateNoNotes()
                }
                
                self.notesData = notes.notes
                
                var articleIDs: [String] = []
                for (articleID, _) in notes.notes {
                    articleIDs.append(articleID)
                }
                self.articleIDsArray = articleIDs.sorted()
                
                guard self.notesData.count == self.articleIDsArray.count else {
                    return self.indicateNoNotes()
                }
                
                self.tableView.reloadData()
                self.tableView.tableFooterView = UIView()
            case .failure(_):
                return self.indicateNoNotes()
            }
        }
    }
    
    private func indicateNoUser() {
        let noUserText = """
Здесь отображаются заметки, которые можно сделать при изучении статей.

Для получения статей необходимо зарегистрироваться в приложении (иконка в правом верхнем углу экрана), после чего подписаться на индикаторы компетенций на вкладке "Подписки".

Настроить расписание получения статей можно с помощью пункта меню "График развития" вкладки "Личный кабинет".
"""
        
        tableView.tableFooterView = TableFooterView.shared.create(with: noUserText, in: self.view, empty: true)
    }
    
    private func indicateNoNotes() {
        let noNoteText = """
К сожалению Вы ещё не делали ни одной заметки при изучении статей.
Воспользуйтесь данной возможностью с помощью соответствующей иконки в правом верхнем углу экрана при прочтении любой статьи.

Если же Вы не получили ни одной статьи, то может быть Вы не подписаны ни на один индиктор компетенций?

Сделать это легко: просто нажмите на понравивщийся индикатор на вкладке "Подписки".

Настроить расписание получения статей можно с помощью пункта меню "График развития" вкладки "Личный кабинет".
"""
        
        tableView.tableFooterView = TableFooterView.shared.create(with: noNoteText, in: self.view, empty: true)
    }
}
