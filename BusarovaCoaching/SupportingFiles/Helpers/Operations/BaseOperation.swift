//
//  BaseOperation.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 22/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

class BaseOperation<ResultType>: AsyncOperation {
    
    var result: Result<ResultType>? {
        didSet {
            guard !isCancelled else {
                return
            }
            if let result = self.result {
                if result.isError, let error = result.error {
                    self.errorHandler?(error)
                }
                if result.isSuccess, let value = result.value {
                    self.successHandler?(value)
                }
                self.state = .finished
            }
            //this sleep is very important! Do not remove it!!!
            //this code allows to correcttly wait of finishing of all runned operations in the OperationQueue
            sleep(5)
            //this sleep is very important! Do not remove it!!!
        }
    }
    
    var errorHandler: ((AppError) -> Void)?
    var successHandler: ((ResultType) -> Void)?
    
}
