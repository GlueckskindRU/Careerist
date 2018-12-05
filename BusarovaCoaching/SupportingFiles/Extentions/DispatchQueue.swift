//
//  DispatchQueue.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 22/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

extension DispatchQueue {

    public func async<T>(_ completion: @escaping (T) -> Void, with result: T) {
        async {
            completion(result)
        }
    }
    
}
