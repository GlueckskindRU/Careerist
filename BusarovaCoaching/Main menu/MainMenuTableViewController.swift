//
//  MainMenuTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 15/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

protocol MainMenuProtocol {
    func menuCaptionTapped(on menuItem: MainMenuModel, at index: Int)
}

protocol MainMenuCellProtocol: class {
    func configure(with menuItem: MainMenuModel, as delegate: MainMenuProtocol, at index: Int)
}

class MainMenuTableViewController: UITableViewController {
    private var menuItems: [MainMenuModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuItems = MainMenuModel.fetchInitialData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        tableView.tableFooterView = UIView()
        
        tableView.insetsContentViewsToSafeArea = true
    }
}

extension MainMenuTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemToPass = menuItems[indexPath.row]
        let cell: MainMenuCellProtocol
        
        switch itemToPass.level {
        case .zero:
            cell = tableView.dequeueReusableCell(withIdentifier: "Main Menu Cell Level 0", for: indexPath) as! MainMenuCellProtocol
        case .one:
            cell = tableView.dequeueReusableCell(withIdentifier: "Main Menu Cell Level 1", for: indexPath) as! MainMenuCellProtocol
        case .two:
            cell = tableView.dequeueReusableCell(withIdentifier: "Main Menu Cell Level 2", for: indexPath) as! MainMenuCellProtocol
        }
        
        cell.configure(with: itemToPass, as: self, at: indexPath.row)
        
        return cell as! UITableViewCell
    }
}

extension MainMenuTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tabBarHeight = (tabBarController?.tabBar.frame.height)!
        let totalHeight = tableView.bounds.height - tabBarHeight
        
        let rowHeight = totalHeight / CGFloat(menuItems.count)
        
        let minimumRowHeight: CGFloat = 36.0

        if rowHeight < minimumRowHeight {
            return minimumRowHeight
        } else {
            return rowHeight
        }
    }
    
}

extension MainMenuTableViewController: MainMenuProtocol {
    func menuCaptionTapped(on menuItem: MainMenuModel, at index: Int) {
        if menuItem.collapsed {
            if menuItem.level != .two {
                expandMenu(with: menuItem.id, at: index)
            }
        } else {
            if menuItem.level == .one {
                collapseMenu(with: menuItem.id, at: index)
            }
            if menuItem.level == .zero {
                let levelOneItems = menuItems.filter { $0.parentId == menuItem.id }
                
                for item in levelOneItems {
                    if let itemIndex = menuItems.index(where: {$0.id == item.id}) {
                        collapseMenu(with: item.id, at: itemIndex)
                    }
                }
                
                collapseMenu(with: menuItem.id, at: index)
            }
        }
    }
}


extension MainMenuTableViewController {
    private func expandMenu(with parentId: Int, at index: Int) {
        let newItems = MainMenuModel.fetchChildernOf(parentId)
        
        menuItems[index].collapsed = false
        
        tableView.beginUpdates()
        for i in index+1..<index+newItems.count {
            menuItems.insert(newItems[i-index-1], at: i)
            tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
        }
        tableView.endUpdates()
        tableView.reloadData()
    }
    
    private func collapseMenu(with parentId: Int, at index: Int) {
        tableView.beginUpdates()
        
        for (i, _) in menuItems.enumerated().reversed() {
            if menuItems[i].parentId == parentId {
                removeMenuItem(at: i)
            }
        }
        
        menuItems[index].collapsed = true
        tableView.endUpdates()
        tableView.reloadData()
    }
    
    private func removeMenuItem(at index: Int) {
        menuItems.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}
