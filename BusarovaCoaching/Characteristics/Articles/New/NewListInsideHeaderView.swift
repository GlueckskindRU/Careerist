//
//  NewListInsideHeaderView.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 04/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class NewListInsideHeaderView: UITableViewHeaderFooterView {
    private var delegate: ListCaptionSaveProtocol?
    
    lazy private var listCaptionTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Заголовок списка. Необязательный"
        textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: UIControl.Event.allEditingEvents)
        
        return textField
    }()
    
    @objc
    private func textFieldDidChange(sender: UITextField) {
        let text = sender.text ?? ""
        
        self.delegate?.saveListCaption(text)
    }
    
    func configure(with caption: String, as delegate: ListCaptionSaveProtocol) {
        self.listCaptionTextField.text = caption
        self.delegate = delegate
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
        contentView.backgroundColor = .white
        contentView.addSubview(listCaptionTextField)
        
        NSLayoutConstraint.activate([
            listCaptionTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            listCaptionTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: listCaptionTextField.trailingAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: listCaptionTextField.bottomAnchor, constant: 16)
            ])
    }
}
