//
//  EditListInsideViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 17/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class EditListInsideViewController: UIViewController {
    private let newLine: Character = "\n"
    private var articleInside: ArticleInside!
    private var saveDelegate: SaveListElementsProtocol!
    
    lazy private var textView: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.showsHorizontalScrollIndicator = false
        textView.isEditable = true
        textView.isSelectable = true
        
        return textView
    }()
    
    func configure(with articleInside: ArticleInside, delegate: SaveListElementsProtocol) {
        self.articleInside = articleInside
        self.saveDelegate = delegate
        textView.text = convertListIntoText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveList(sender:)))
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ])
    }
}

// MARK: - Auxiliary functions
extension EditListInsideViewController {
    private func convertListIntoText() -> String {
        return articleInside.listElements!.joined(separator: "\(newLine)")
    }
    
    private func convertTextIntoList() -> [String] {
        if textView.text != nil {
            return textView.text!.split(separator: newLine).map { "\($0)" }
        } else {
            return []
        }
    }
    
    @objc
    private func saveList(sender: UIBarButtonItem) {
        saveDelegate.saveListElements(convertTextIntoList())
        navigationController?.popViewController(animated: true)
    }
}
