//
//  NewTestQuestionHederView.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 03/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class NewTestQuestionHederView: UITableViewHeaderFooterView {
    private var delegate: TestQuestionSaveProtocol?
    
    lazy private var testQuestionTextView: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.delegate = self
        
        return textView
    }()
    
    func configure(with question: String, as delegate: TestQuestionSaveProtocol) {
        testQuestionTextView.text = question
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
        contentView.addSubview(testQuestionTextView)
        
        NSLayoutConstraint.activate([
            testQuestionTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            testQuestionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: testQuestionTextView.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: testQuestionTextView.bottomAnchor, constant: 16)
            ])
    }
}

extension NewTestQuestionHederView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.saveTestQuestion(testQuestionTextView.text)
    }
}
