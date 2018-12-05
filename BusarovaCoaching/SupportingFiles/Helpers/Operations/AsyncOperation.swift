//
//  AsyncOperation.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 22/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

open class AsyncOperation: Operation {
    
    public enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: KeyPath<AsyncOperation, Bool> {
            switch self {
            case .executing:
                return \AsyncOperation.isExecuting
            case .finished:
                return \AsyncOperation.isFinished
            case .ready:
                return \AsyncOperation.isReady
            }
            
        }
    }
    
    public var state: State = .ready {
        willSet {
            willChangeValue(for: newValue.keyPath)
            willChangeValue(for: state.keyPath)
        }
        didSet {
            didChangeValue(for: oldValue.keyPath)
            didChangeValue(for: state.keyPath)
        }
    }
    
    override open var isAsynchronous: Bool {
        return true
    }
    
    override open var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override open var isFinished: Bool {
        return state == .finished
    }
    
    override open var isExecuting: Bool {
        return state == .executing
    }
    
    override open func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        self.state = .executing
    }
    
    override open func cancel() {
        super.cancel()
        state = .finished
    }
}
