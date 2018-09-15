//
//  NotesTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    private var notesData: [NotesModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(NotesCell.self, forCellReuseIdentifier: "Notes Cell")
        tableView.tableFooterView = UIView()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        navigationItem.title = "Мои записи"
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        FirebaseController.shared.getDataController().fetchData(DBTables.notes) {
            (result: Result<[NotesModel]>) in
            
            
            activityIndicator.stop()
            switch result {
            case .success(let notes):
                self.notesData = notes
                self.tableView.reloadData()
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = DetailedNoteViewController()
        
        destination.configure(with: notesData[indexPath.row])
        
        navigationController?.pushViewController(destination, animated: true)
    }
}
