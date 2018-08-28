//
//  NotesTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    private var notesData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesData = CabinetModel.fetchNotes()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(NotesCell.self, forCellReuseIdentifier: "Notes Cell")
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Мои записи"
    }
}

extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Notes Cell", for: indexPath) as! NotesCell
        
        cell.configure(with: notesData[indexPath.row])
        
        return cell
    }
}

extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = DetailedNoteViewController()
        
        destination.configure(with: notesData[indexPath.row])
        
        navigationController?.pushViewController(destination, animated: true)
    }
}