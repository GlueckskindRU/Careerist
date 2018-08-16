//
//  DevelopmentCell.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class DevelopmentCell: UITableViewCell {
    private var enhancedCell: Bool = false
    lazy private var cellCaption: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy)
        
        return label
    }()
    
    lazy private var frequencyLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    lazy private var frequencyDaysLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    lazy private var frequencyTimeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    lazy private var frequencyPerDay: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    lazy private var questionsForSelfAnalysis: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    func configure(with caption: String, as enhanced: Bool) {
        self.enhancedCell = enhanced
        self.cellCaption.text = caption
        self.frequencyLabel.text = "Периодичность"
        self.frequencyDaysLabel.text = "Пн Вт Ср Чт Пт Сб Вс"
        self.frequencyTimeLabel.text = "Время: 10:12"
        
        contentView.addSubview(cellCaption)
        contentView.addSubview(frequencyLabel)
        contentView.addSubview(frequencyDaysLabel)
        contentView.addSubview(frequencyTimeLabel)
        
        if enhanced {
            frequencyPerDay.text = "Количество в день: 1"
            questionsForSelfAnalysis.text = "Вопросы для самоанализа: да/нет"
            
            contentView.addSubview(frequencyPerDay)
            contentView.addSubview(questionsForSelfAnalysis)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if enhancedCell {
            NSLayoutConstraint.activate([
                cellCaption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                cellCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                contentView.trailingAnchor.constraint(equalTo: cellCaption.trailingAnchor, constant: 8),
                
                frequencyLabel.topAnchor.constraint(equalTo: cellCaption.bottomAnchor, constant: 4),
                frequencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                contentView.trailingAnchor.constraint(equalTo: frequencyLabel.trailingAnchor, constant: 8),
                
                frequencyDaysLabel.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: 4),
                frequencyDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                contentView.trailingAnchor.constraint(equalTo: frequencyDaysLabel.trailingAnchor, constant: 8),
                
                frequencyPerDay.topAnchor.constraint(equalTo: frequencyDaysLabel.bottomAnchor, constant: 4),
                frequencyPerDay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                contentView.trailingAnchor.constraint(equalTo: frequencyPerDay.trailingAnchor, constant: 8),
                
                frequencyTimeLabel.topAnchor.constraint(equalTo: frequencyPerDay.bottomAnchor, constant: 4),
                frequencyTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                contentView.trailingAnchor.constraint(equalTo: frequencyTimeLabel.trailingAnchor, constant: 8),
                
                questionsForSelfAnalysis.topAnchor.constraint(equalTo: frequencyTimeLabel.bottomAnchor, constant: 4),
                questionsForSelfAnalysis.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                contentView.trailingAnchor.constraint(equalTo: questionsForSelfAnalysis.trailingAnchor, constant: 8),
                contentView.bottomAnchor.constraint(equalTo: questionsForSelfAnalysis.bottomAnchor, constant: 8)
                ])
            
            cellCaption.sizeToFit()
            frequencyLabel.sizeToFit()
            frequencyDaysLabel.sizeToFit()
            frequencyTimeLabel.sizeToFit()
            frequencyPerDay.sizeToFit()
            questionsForSelfAnalysis.sizeToFit()
        } else {
            NSLayoutConstraint.activate([
                cellCaption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                cellCaption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                contentView.trailingAnchor.constraint(equalTo: cellCaption.trailingAnchor, constant: 8),
                
                frequencyLabel.topAnchor.constraint(equalTo: cellCaption.bottomAnchor, constant: 4),
                frequencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                contentView.trailingAnchor.constraint(equalTo: frequencyLabel.trailingAnchor, constant: 8),
                
                frequencyDaysLabel.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: 4),
                frequencyDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                contentView.trailingAnchor.constraint(equalTo: frequencyDaysLabel.trailingAnchor, constant: 8),
                
                frequencyTimeLabel.topAnchor.constraint(equalTo: frequencyDaysLabel.bottomAnchor, constant: 4),
                frequencyTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                contentView.trailingAnchor.constraint(equalTo: frequencyTimeLabel.trailingAnchor, constant: 8),
                contentView.bottomAnchor.constraint(equalTo: frequencyTimeLabel.bottomAnchor, constant: 8)
                ])
            
            cellCaption.sizeToFit()
            frequencyLabel.sizeToFit()
            frequencyDaysLabel.sizeToFit()
            frequencyTimeLabel.sizeToFit()
        }
    }
}
