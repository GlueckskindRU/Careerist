//
//  QuestionView.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 11/01/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    @IBOutlet weak var questionTextLabel: UILabel!
    
    @IBOutlet weak var numberOfQuestionsLabel: UILabel!
    
    @IBOutlet weak var selectionRuleLabel: UILabel!
    
    func configure(with question: String, sequence: Int, total: Int, multipleSelection: Bool) {
        questionTextLabel.text = question
        
        if multipleSelection {
            selectionRuleLabel.text = "Выберите несколько вариантов ответа"
        } else {
            selectionRuleLabel.text = "Выберите только один вариант"
        }
        
        numberOfQuestionsLabel.text = "Вопрос № \(sequence) из \(total)"
        
    }
}
