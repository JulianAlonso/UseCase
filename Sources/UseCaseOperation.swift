//
//  UseCaseOperation.swift
//  UseCase
//
//  Created by Julián Alonso Carballo on 13/2/17.
//  Copyright © 2017 com.julian. All rights reserved.
//

import Foundation

public final class UseCaseOperation<Request, Response>: BaseOperation {
    
    public typealias CommonBlock = () -> Void
    public typealias ThenBlock = (Response) -> Void
    public typealias CatchBlock = (Error) -> Void
    
    private var commons: [CommonBlock] = []
    private var thens: [ThenBlock] = []
    private var catchs: [CatchBlock] = []
    
    private let queue = DispatchQueue(label: "UseCaseOperationQueue")
    
    public var response: Response? {
        didSet {
            self.finish()
            self.checkIfEnded()
        }
    }
    
    public var error: Error? {
        didSet {
            self.finish()
            self.checkIfEnded()
        }
    }
    
    let execution: (UseCaseOperation<Request, Response>) -> ()
    
    public init(execution: @escaping (UseCaseOperation<Request, Response>) -> ()) {
        self.execution = execution
    }
    
    override public func main() {
        self.execution(self)
    }
    
    @discardableResult public func common(_ common: @escaping CommonBlock) -> Self {
        self.queue.sync {
            self.commons.append(common)
        }
        self.checkIfEnded()
        return self
    }
    
    @discardableResult public func then(_ then: @escaping ThenBlock) -> Self {
        self.queue.sync {
            self.thens.append(then)
        }
        self.checkIfEnded()
        return self
    }
    
    @discardableResult public func `catch`(_ `catch`: @escaping CatchBlock) -> Self {
        self.queue.sync {
            self.catchs.append(`catch`)
        }
        self.checkIfEnded()
        return self
    }
    
    private func end<T>(_ blocks: inout [(T) -> Void], _ with: T) {
        self.queue.sync {
            while !blocks.isEmpty {
                if let first = blocks.first {
                    DispatchQueue.main.async {
                        first(with)
                    }
                    var newBlocks: [(T) -> Void] = []
                    for i in 0..<blocks.count {
                        if i > 0 {
                            newBlocks.append(blocks[i])
                        }
                    }
                    blocks = newBlocks
                }
            }
        }
    }
    
    private func finish() {
        if !self.isCancelled {
            self.state = .Finished
        }
    }
    
    private func executeCommons() {
        self.queue.sync {
            while !self.commons.isEmpty {
                if let first = commons.first {
                    DispatchQueue.main.async {
                        first()
                    }
                    var newBlocks: [CommonBlock] = []
                    for i in 0..<self.commons.count {
                        if i > 0 {
                            newBlocks.append(self.commons[i])
                        }
                    }
                    self.commons = newBlocks
                }
            }
        }
    }
    
    private func clear() {
        self.commons = []
        self.thens = []
        self.catchs = []
    }
    
    private func checkIfEnded() {
        if self.isCancelled {
            self.clear()
            self.state = .Finished
            return
        }
        if let response = self.response {
            self.executeCommons()
            self.end(&self.thens, response)
        }
        if let error = self.error {
            self.executeCommons()
            self.end(&self.catchs, error)
        }
    }
    
}
