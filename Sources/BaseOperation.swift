//
//  BaseOperation.swift
//  UseCase
//
//  Created by Julián Alonso Carballo on 13/2/17.
//  Copyright © 2017 com.julian. All rights reserved.
//

import Foundation

public class BaseOperation: Operation {
    
    enum State: String {
        case Ready
        case Executing
        case Finished
        
        var keyPath: String {
            return "is\(self.rawValue)"
        }
    }
    
    override public var isAsynchronous: Bool { return true }
    
    var state = State.Ready {
        willSet {
            self.willChangeValue(forKey: self.state.keyPath)
            self.willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            self.didChangeValue(forKey: oldValue.keyPath)
            self.didChangeValue(forKey: self.state.keyPath)
        }
    }
    
    override public var isExecuting: Bool {
        return self.state == .Executing
    }
    
    override public var isFinished: Bool {
        return self.state == .Finished
    }
    
    override public func start() {
        if self.isCancelled {
            state = .Finished
        } else {
            state = .Ready
            self.main()
        }
    }
    
}
