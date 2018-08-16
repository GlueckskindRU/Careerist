//
//  DetailedNoteViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class DetailedNoteViewController: UIViewController {
    lazy private var text: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = true
        textView.showsHorizontalScrollIndicator = false
        
        return textView
    }()
    
    func configure(with noteCaption: String) {
        navigationItem.title = noteCaption
        
        text.text = CabinetModel.articleText
        
        view.addSubview(text)
        
        NSLayoutConstraint.activate([
            text.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            text.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: text.trailingAnchor, constant: 8),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 8)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
}
