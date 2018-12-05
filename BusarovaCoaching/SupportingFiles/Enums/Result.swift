//
//  Result.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(AppError)
}

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var isError: Bool {
        return !isSuccess
    }
    
    var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    var error: AppError? {
        switch self {
        case .failure(let error):
            return error
        case .success:
            return nil
        }
    }
}
