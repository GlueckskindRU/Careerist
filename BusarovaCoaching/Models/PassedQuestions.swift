//
//  PassedQuestions.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/01/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import Foundation

struct PassedQuestions: Codable, Hashable {
    let competenceID: String
    let earnedPoints: Int
    let totalPoints: Int
    var details: Set<Details>
    
    struct Details: Codable, Hashable {
        let questionID: String
        let passed: Bool
        let snoozedTill: Date?
        
        init(questionID: String, passed: Bool, snoozedTill: Date?) {
            self.questionID = questionID
            self.passed = passed
            self.snoozedTill = snoozedTill
        }
    }
    
    init(competenceID: String, earnedPoints: Int, totalPoints: Int, details: Set<Details>) {
        self.competenceID = competenceID
        self.earnedPoints = earnedPoints
        self.totalPoints = totalPoints
        self.details = details
    }
}
