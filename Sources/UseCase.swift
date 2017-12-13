//
//  UseCase.swift
//  UseCase
//
//  Created by Julián Alonso Carballo on 13/2/17.
//  Copyright © 2017 com.julian. All rights reserved.
//

import Foundation

public protocol UseCaseRequest {
    
}

public protocol UseCaseResponse {
    
}

open class UseCase<Request, Response> {
    
    let queue: OperationQueue
    
    public init(_ queue: OperationQueue) {
        self.queue = queue
    }
    
    public func execute(_ request: Request? = nil) -> UseCaseOperation<Request, Response> {
        let operation = UseCaseOperation<Request,Response> { self.main(request: request, $0) }
        self.queue.addOperation(operation)
        return operation
    }
    
    open func main(request: Request?, _ operation: UseCaseOperation<Request, Response>) {
        fatalError("Calling not implemented use case \(self)")
    }
    
}

