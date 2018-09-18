//
//  NewCharacteristicsArticleHeaderView.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 13/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class NewCharacteristicsArticleHeaderView: UITableViewHeaderFooterView {
    private var delegate: ArticleTitleSaveProtocol?
    
    lazy private var articleTitleTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Заголовок статьи. Обязательный"
        textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: UIControl.Event.allEditingEvents)
        
        return textField
    }()
    
    @objc
    private func textFieldDidChange(sender: UITextField) {
        let text = sender.text ?? ""
        
        self.delegate?.saveArticleTitle(text)
    }
    
    func configure(with article: Article?, as delegate: ArticleTitleSaveProtocol) {
        self.delegate = delegate
        guard let article = article else {
            return
        }
        self.articleTitleTextField.text = article.title
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(articleTitleTextField)
        
        NSLayoutConstraint.activate([
            articleTitleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            articleTitleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: articleTitleTextField.trailingAnchor, constant: 8),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: articleTitleTextField.bottomAnchor, constant: 16)
            ])
    }
}
