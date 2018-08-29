//
//  DescriptionViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    lazy private var titleView: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy private var captionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy private var text: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = true
        textView.showsHorizontalScrollIndicator = false
        
        return textView
    }()
    
    func configure(with article: AboutArticlesModel) {
        titleView.text = WelcomeModel.headerText
        captionLabel.text = article.name
        text.text = article.text
        
        view.addSubview(titleView)
        view.addSubview(captionLabel)
        view.addSubview(text)
        
        titleView.sizeToFit()
        captionLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 8),
            
            captionLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            captionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 8),
            
            text.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 16),
            text.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: text.trailingAnchor, constant: 8),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 8)
            ])
    }
}
