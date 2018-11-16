//
//  TimeSaveDelegateProtocol.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

protocol TimeSaveDelegateProtocol {
    func setTime(hour: Int, minute: Int, as type: ArticleType)
}
