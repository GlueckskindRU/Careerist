//
//  NewAdviceViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 08/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class NewAdviceViewController: UIViewController {
    private var advice: Article? = nil
    private var sequence: Int? = nil
    private var parentID: String?
    private var adviceInside: UIArticleInside?
    private let dataService = DataService()
    
    lazy private var saveBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped(sender:)))
    }()
    
    lazy private var captionTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " Загаловок совета дня. Необязательный"
        textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.leftViewMode = UITextField.ViewMode.always
        textField.delegate = self
        
        return textField
    }()
    
    lazy private var textView: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.showsHorizontalScrollIndicator = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.delegate = self
        
        return textView
    }()
    
    private var isSaved: Bool = true {
        didSet {
            saveBarButtonItem.isEnabled = !isSaved
        }
    }
    
    func configure(with advice: Article?, as sequence: Int, parentID: String?) {
        self.advice = advice
        self.sequence = sequence
        self.parentID = parentID
        
        guard let advice = advice else {
            self.adviceInside = nil
            return
        }
        
        captionTextField.text = advice.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupLayout()
        
        saveBarButtonItem.isEnabled = !isSaved
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.title = "Совет дня"
        
        refreshUI()
    }
}

// MARK: - objc private functions
extension NewAdviceViewController {
    @objc
    private func saveButtonTapped(sender: UIBarButtonItem) {
        let id: String?
        
        guard
            let sequence = sequence,
            let parentID = parentID else {
            return
        }
        
        guard
            let adviceText = textView.text,
            let title = captionTextField.text else {
                return
        }
        
        if adviceText.isEmpty && title.isEmpty {
            isSaved = true
            return
        }
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        if advice == nil {
            id = nil
            advice = Article(id: "",
                             title: title,
                             parentID: parentID,
                             parentType: DBTables.characteristics.rawValue,
                             sequence: sequence,
                             grants: 0, // to be amended
                             authorID: "1", // to be amended
                             rating: 0,
                             verified: false,
                             type: ArticleType.advice
                            )
        } else {
            id = advice!.id
            advice = Article(id: id!,
                             title: title,
                             parentID: parentID,
                             parentType: advice!.parentType,
                             sequence: sequence,
                             grants: advice!.grants,
                             authorID: advice!.authorID,
                             rating: advice!.rating,
                             verified: advice!.verified,
                             type: ArticleType.advice
                            )
        }
        
        dataService.saveArticle(advice!, with: id) {
            (result: Result<Article>) in
            
            activityIndicator.stop()
            switch result {
            case .success(let advice):
                self.advice = advice
                self.saveAdviceInside(of: advice, with: adviceText)
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
}

// MARK: - Auxiliary functions
extension NewAdviceViewController {
    private func refreshUI() {
        guard let advice = advice else {
            adviceInside = nil
            return
        }
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        dataService.fetchArticle(with: advice.id, forPreview: false) {
            (result: Result<[UIArticleInside]>) in
            
            activityIndicator.stop()
            
            switch result {
            case .success(let insideArray):
                self.adviceInside = insideArray[0]
                self.textView.text = insideArray[0].text
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
    
    private func setupLayout() {
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
    
    private func saveAdviceInside(of advice: Article, with text: String) {
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        let adviceInsideID = adviceInside?.id ?? nil
        
        adviceInside  = UIArticleInside(id: adviceInside?.id ?? "",
                                        parentID: advice.id,
                                        sequence: 0,
                                        type: .text,
                                        caption: nil,
                                        text: text,
                                        image: nil,
                                        imageURL: nil,
                                        imageStorageURL: nil,
                                        imageName: nil,
                                        numericList: nil,
                                        listElements: nil
                                        )
        
        dataService.saveArticleInside(adviceInside!, with: adviceInsideID) {
            (result: Result<UIArticleInside>) in
            
            activityIndicator.stop()
            
            switch result {
            case .success(let adviceInside):
                self.adviceInside = adviceInside
                self.isSaved = true
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
}

// MARK: - TextFieldDelegate
extension NewAdviceViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if
            textField == captionTextField
        &&  textField.text!.isEmpty
            &&  textView.text.isEmpty {
            isSaved = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == captionTextField && range.length > 0 {
            isSaved = false
        }
        
        return true
    }
}

// MARK: - TextViewDelegate
extension NewAdviceViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.textView {
            isSaved = false
            
            if textView.text.isEmpty && captionTextField.text!.isEmpty {
                isSaved = true
            }
        }
    }
}
