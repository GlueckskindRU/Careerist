//
//  Result.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(AppError)
}
