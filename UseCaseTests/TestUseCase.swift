//
//  TestUseCase.swift
//  UseCase
//
//  Created by Julián Alonso Carballo on 13/2/17.
//  Copyright © 2017 com.julian. All rights reserved.
//

import Foundation

struct TestRequest: UseCaseRequest {
    
}

struct TestResponse: UseCaseResponse {
    
}

enum TestError: Error {
    case noRequest
}

final class TestUseCase: UseCase<TestRequest, TestResponse> {
    
    override func main(request: TestRequest?, _ operation: UseCaseOperation<TestRequest, TestResponse>) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .milliseconds(600)) {
            if request != nil {
                operation.response = TestResponse()
            } else {
                operation.error = TestError.noRequest
            }
        }
    }
    
}
