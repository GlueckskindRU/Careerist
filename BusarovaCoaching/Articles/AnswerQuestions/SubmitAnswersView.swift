//
//  SubmitAnswersView.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 11/01/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class SubmitAnswersView: UIView {
    private var delegate: SubmitedAnswersProcessingProtocol?
    
    func configure(with delegate: SubmitedAnswersProcessingProtocol, questionAlreadyPassed: Bool, snoozedTill: Date?) {
        self.delegate = delegate
        
        if let snoozedTill = snoozedTill {
            submitAnswerButtonOutlet.isEnabled = false
            submitAnswerButtonOutlet.isHidden = true
            TimaSnoozedLabel.isEnabled = true
            TimaSnoozedLabel.isHidden = false
            
            TimaSnoozedLabel.text = "Вы сможете повторно ответить на данный вопрос только после \(snoozedTill.dateWithTimeFormatting)."
        } else {
            submitAnswerButtonOutlet.isEnabled = !questionAlreadyPassed
            submitAnswerButtonOutlet.isHidden = questionAlreadyPassed
            TimaSnoozedLabel.isEnabled = false
            TimaSnoozedLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var TimaSnoozedLabel: UILabel!
    @IBOutlet weak var submitAnswerButtonOutlet: UIButton!
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        delegate?.preceedWithSubmittedAnswers()
    }
}
