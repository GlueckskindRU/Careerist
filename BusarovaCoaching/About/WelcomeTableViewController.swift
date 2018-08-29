//
//  WelcomeTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class WelcomeTableViewController: UITableViewController, DataControllerProtocol {
    private var articles: [AboutArticlesModel] = []
    internal var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = UINib(nibName: "WelcomeFooterXIB", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
        
        dataController.fetchData(.aboutArticles) {
            (documents) in
            for document in documents {
                let data = document.data()
                self.articles.append(AboutArticlesModel(id: document.documentID,
                                                        name: data["name"] as! String,
                                                        text: data["text"] as! String
                                                        ))
            }
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
        let destination = segue.destination as? DescriptionViewController,
        let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        destination.configure(with: articles[indexPath.row])
    }
}

extension WelcomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem Cell", for: indexPath) as! WelcomeTableCell
        
        cell.configure(with: articles[indexPath.row])
        
        return cell
    }
}

extension WelcomeTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
//        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
