//
//  ScheduleCellDelegateProtocol.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

protocol ScheduleCellDelegateProtocol {
    func setSchedulingFrequency(_ frequency: DayOfWeek, for type: ArticleType)
    func callTimePicker(for type: ArticleType)
    func testQuestionsValueChanged(to value: Bool, for type: ArticleType)
}
