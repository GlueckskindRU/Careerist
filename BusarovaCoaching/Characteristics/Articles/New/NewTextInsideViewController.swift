//
//  NewTextInsideViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class NewTextInsideViewController: UIViewController, ArticleInsideElementsProtocol {
    private var articleInside: ArticleInside? = nil
    private var isSaved: Bool = false
    private var sequence: Int? = nil
    private var articleSaveDelegate: ArticleSaveDelegateProtocol?
    
    lazy private var captionTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " Загаловок абзаца. Необязательный"
        textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.leftViewMode = UITextFieldViewMode.always
        
        return textField
    }()
    
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
    
    func configure(with articleInside: ArticleInside?, as sequence: Int, delegate: ArticleSaveDelegateProtocol) {
        self.articleInside = articleInside
        self.sequence = sequence
        self.articleSaveDelegate = delegate
        
        self.captionTextField.text = articleInside?.caption
        self.textView.text = articleInside?.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Абзац текста"
        
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveText(sender:)))
        saveBarButtonItem.isEnabled = !isSaved
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        view.addSubview(captionTextField)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            captionTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            captionTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: captionTextField.trailingAnchor, constant: 8),
            captionTextField.heightAnchor.constraint(equalToConstant: 30),
            
            textView.topAnchor.constraint(equalTo: captionTextField.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ])
    }
}

// MARK: - saving data
extension NewTextInsideViewController {
    @objc
    private func saveText(sender: UIBarButtonItem) {
        guard let sequence = sequence else {
            return
        }
        
        let articleInsideID: String?
        if articleInside == nil {
            articleInsideID = nil
        } else {
            articleInsideID = articleInside!.id
        }
        
        let elementToSave = ArticleInside(id: articleInside?.id ?? "",
                                          parentID: articleInside?.parentID ?? "",
                                          sequence: sequence,
                                          type: .text,
                                          caption: captionTextField.text,
                                          text: textView.text,
                                          imageURL: nil,
                                          imageName: nil,
                                          numericList: nil,
                                          listElements: nil
                                            )
        articleSaveDelegate?.saveArticle(articleInside: elementToSave, with: articleInsideID)
        navigationController?.popViewController(animated: true)
    }
}
