//
//  AboutHardcodedArticleTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 07/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class AboutHardcodedArticleTableViewController: UITableViewController {
    private let videoCell = "Video Cell"
    private let textCell = "Text Cell"
    private var navigationTitle: String = ""
    
    lazy private var customBackButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Assets.backArrow.rawValue),
                               style: UIBarButtonItem.Style.plain,
                               target: self,
                               action: #selector(customBackButtonTapped(_:))
        )
    }()
    
    func configure(with title: String) {
        navigationTitle = title
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.tableFooterView = UIView()
        
        tableView.register(ArticleHardcodedTextCell.self, forCellReuseIdentifier: textCell)
        tableView.register(UINib(nibName: String(describing: VideoCell.self), bundle: nil), forCellReuseIdentifier: videoCell)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = customBackButton
        
        navigationItem.title = navigationTitle
        if let tintColor = UIColor(named: "aboutTintColor") {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: tintColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
            ]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationMultilineTitle()
        tableView.reloadData()
    }
}

// MARK: - TableView DataSourse
extension AboutHardcodedArticleTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WelcomeModel.hardcodedArticleText.count + WelcomeModel.hardcodedVideoIds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: textCell, for: indexPath) as? ArticleHardcodedTextCell else {
                return cell
            }
            textCell.configure(with: WelcomeModel.hardcodedArticleText[0])
            cell = textCell
        case 1:
            guard let videoCell = tableView.dequeueReusableCell(withIdentifier: videoCell, for: indexPath) as? VideoCell else {
                return cell
            }
            
            videoCell.configure(with: WelcomeModel.hardcodedVideoIds[0])
            cell = videoCell
        case 2:
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: textCell, for: indexPath) as? ArticleHardcodedTextCell else {
                return cell
            }
            textCell.configure(with: WelcomeModel.hardcodedArticleText[1])
            cell = textCell
        case 3:
            guard let videoCell = tableView.dequeueReusableCell(withIdentifier: videoCell, for: indexPath) as? VideoCell else {
                return cell
            }

            videoCell.configure(with: WelcomeModel.hardcodedVideoIds[1])
            cell = videoCell
        case 4:
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: textCell, for: indexPath) as? ArticleHardcodedTextCell else {
                return cell
            }
            textCell.configure(with: WelcomeModel.hardcodedArticleText[2])
            cell = textCell
        case 5:
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: textCell, for: indexPath) as? ArticleHardcodedTextCell else {
                return cell
            }
            textCell.configure(with: WelcomeModel.hardcodedArticleText[3])
            cell = textCell
        default:
            return cell
        }
        
        return cell
    }
}

