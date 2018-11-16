//
//  ArticlesScheduleCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class ArticlesScheduleCell: UITableViewCell, MultiSelectSegmentedControlDelegate {
    @IBOutlet weak var frequencySegmentedControl: MultiSelectSegmentedControl!
    @IBOutlet weak var setupTimeButton: UIButton!
    @IBOutlet weak var withQuestionSwitch: UISwitch!
    
    private var frequency: DayOfWeek = []
    private var delegate: ScheduleCellDelegateProtocol?
    
    @IBAction func withQuestionSwitchTapped(_ sender: UISwitch) {
        withQuestionSwitch.setOn(sender.isOn, animated: true)
        delegate?.testQuestionsValueChanged(to: sender.isOn, for: .article)
    }
    
    @IBAction func setupTimeButton(_ sender: UIButton) {
        delegate?.callTimePicker(for: .article)
    }
    
    func configure(with articlesSchedule: SubscriptionArticleSchedule, delegate: ScheduleCellDelegateProtocol, loggedUser: Bool) {
        self.delegate = delegate
        
        frequencySegmentedControl.delegate = self
        setupSegmentedControl(with: articlesSchedule.frequency)
        setupTimeChangingButton(hour: articlesSchedule.hour, minute: articlesSchedule.minute)
        
        withQuestionSwitch.setOn(articlesSchedule.withQuestions, animated: false)
        
        frequencySegmentedControl.isEnabled = loggedUser
        setupTimeButton.isEnabled = loggedUser
        withQuestionSwitch.isEnabled = loggedUser
    }
    
    private func setupTimeChangingButton(hour: Int, minute: Int) {
        let hourString = hour < 10 ? "0\(hour)" : "\(hour)"
        let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
        
        setupTimeButton.setTitle("\(hourString):\(minuteString)", for: UIControl.State.normal)
    }
    
    private func setupSegmentedControl(with frequency: DayOfWeek) {
        self.frequency = frequency
        
        if frequency.contains(.monday) {
            frequencySegmentedControl.selectedSegmentIndexes.insert(0)
        }
        
        if frequency.contains(.tuesday) {
            frequencySegmentedControl.selectedSegmentIndexes.insert(1)
        }
        
        if frequency.contains(.wednesday) {
            frequencySegmentedControl.selectedSegmentIndexes.insert(2)
        }
        
        if frequency.contains(.thursday) {
            frequencySegmentedControl.selectedSegmentIndexes.insert(3)
        }
        
        if frequency.contains(.friday) {
            frequencySegmentedControl.selectedSegmentIndexes.insert(4)
        }
        
        if frequency.contains(.saturday) {
            frequencySegmentedControl.selectedSegmentIndexes.insert(5)
        }
        
        if frequency.contains(.sunday) {
            frequencySegmentedControl.selectedSegmentIndexes.insert(6)
        }
    }
    
    internal func multiSelect(multiSelectSegmendedControl: MultiSelectSegmentedControl, didChangeValue value: Bool, atIndex index: Int) {
        switch index {
        case 0:
            if value {
                frequency.insert(.monday)
            } else {
                frequency.remove(.monday)
            }
        case 1:
            if value {
                frequency.insert(.tuesday)
            } else {
                frequency.remove(.tuesday)
            }
        case 2:
            if value {
                frequency.insert(.wednesday)
            } else {
                frequency.remove(.wednesday)
            }
        case 3:
            if value {
                frequency.insert(.thursday)
            } else {
                frequency.remove(.thursday)
            }
        case 4:
            if value {
                frequency.insert(.friday)
            } else {
                frequency.remove(.friday)
            }
        case 5:
            if value {
                frequency.insert(.saturday)
            } else {
                frequency.remove(.saturday)
            }
        default:
            if value {
                frequency.insert(.sunday)
            } else {
                frequency.remove(.sunday)
            }
        }
        delegate?.setSchedulingFrequency(frequency, for: .article)
    }
}
