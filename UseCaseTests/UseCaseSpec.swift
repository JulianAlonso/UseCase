//
//  UseCaseSpec.swift
//  UseCase
//
//  Created by Julián Alonso Carballo on 13/2/17.
//  Copyright © 2017 com.julian. All rights reserved.
//

import Foundation
//import Quick
//import Nimble
//
//final class UseCaseSpec: QuickSpec {
//    
//    lazy var queue: OperationQueue = {
//        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 2
//        queue.name = "UseCaseSpecQueue"
//        return queue
//    }()
//    
//    override func spec() {
//        
//        let useCase = TestUseCase(self.queue)
//        
//        describe("Test Use Case") { 
//            
//            it("When pass a request, then TestResponse") {
//                waitUntil { done in
//                    useCase.execute(TestRequest()).then { response in
//                        expect(response).toNot(beNil())
//                        print("Operation count: \(self.queue.operationCount)")
//                        done()
//                    }
//                    .catch { (error) in
//                        fail("Not expected error \(error)")
//                    }
//                }
//            }
//            
//            it("When request is nil, catch .noRequest error") {
//                waitUntil { done in
//                    useCase.execute(nil).then { response in
//                        fail("Not expected response \(response)")
//                    }
//                    .catch { error in
//                        expect(error).to(matchError(TestError.noRequest))
//                        done()
//                    }
//                }
//            }
//            
//            context("Executing common blocks") {
//                
//                it("Execute common when pass a request") {
//                    waitUntil { done in
//                        var common = false
//                        useCase.execute(TestRequest()).common {
//                            common = true
//                        }
//                        .then { _ in
//                            expect(common).to(beTrue())
//                            done()
//                        }
//                    }
//                }
//                
//                it("Execute common when request is nil") {
//                    waitUntil { done in
//                        var common = false
//                        useCase.execute(nil).common {
//                            common = true
//                        }
//                        .catch { error in
//                            expect(common).to(beTrue())
//                            done()
//                        }
//                    }
//                }
//                
//            }
//            
//            context("More than one block") {
//                
//                it("Excutes two common and three then") {
//                    waitUntil { done in
//                        var commonCount = 0
//                        var thenCount = 0
//                        useCase.execute(TestRequest()).common {
//                            commonCount += 1
//                        }
//                        .common {
//                            commonCount += 1
//                        }
//                        .then { _ in
//                            thenCount += 1
//                        }
//                        .then { _ in
//                            thenCount += 1
//                        }
//                        .then { _ in
//                            expect(commonCount).to(equal(2))
//                            expect(thenCount).to(equal(2))
//                            done()
//                        }
//                    }
//                }
//                
//                it("Executes two common and three catch") {
//                    waitUntil { done in
//                        var commonCount = 0
//                        var catchCount = 0
//                        useCase.execute(nil).common {
//                            commonCount += 1
//                        }
//                        .common {
//                            commonCount += 1
//                        }
//                        .catch { _ in
//                            catchCount += 1
//                        }
//                        .catch { _ in
//                            catchCount += 1
//                        }
//                        .catch { _ in
//                            expect(commonCount).to(equal(2))
//                            expect(catchCount).to(equal(2))
//                            done()
//                        }
//                    }
//                }
//                
//            }
//            
//            describe("Use case works under operations then operation: ") {
//                
//                it("Must be finished when then is executed and queue count must be 0") {
//                    waitUntil { done in
//                        var operation: Operation?
//                        operation = useCase.execute(TestRequest()).then { response in
//                            expect(operation).toNot(beNil())
//                            expect(operation?.isFinished).to(beTrue())
//                            expect(self.queue.operationCount).to(equal(0))
//                            done()
//                        }
//                    }
//                }
//                
//                it("When it's cancelled, nothing must be executed and queue count must be 0") {
//                    waitUntil(timeout: 2) { done in
//                        var operation: Operation?
//                        operation = useCase.execute(TestRequest()).common {
//                            fail("This should not be executed")
//                        }
//                        .then { response in
//                            fail("This should not be executed")
//                        }
//                        .catch { error in
//                            fail("This should not be executed")
//                        }
//                        operation?.cancel()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//                            expect(self.queue.operationCount).to(equal(0))
//                            done()
//                        }
//                    }
//                }
//                
//            }
//            
//            
//            describe("FIX BUG: Use case have a deadlock when calling method#executeCommons when add a common, then, chatch block and operation is actually ended") {
//                /**
//                 OLD CODE
//                 @discardableResult public func then(_ then: @escaping ThenBlock) -> Self {
//                    self.queue.sync {
//                        self.thens.append(then)
//                        self.checkIfEnded()
//                    }
//                    return self
//                 }
//                 NEW CODE - RESOLVES THE DEADLOCK
//                 @discardableResult public func then(_ then: @escaping ThenBlock) -> Self {
//                     self.queue.sync {
//                         self.thens.append(then)
//                     }
//                     self.checkIfEnded()
//                     return self
//                 }
//                */
//                it("Dont must fail") {
//                    let usecase = TestDeadlockUseCase(self.queue)
//                    waitUntil(timeout: 3) { done in
//                        var commonCount = 0
//                        var thenCount = 0
//                        
//                        let operation = usecase.execute(nil).common {
//                            commonCount += 1
//                        }.common {
//                            commonCount += 1
//                        }.common {
//                            commonCount += 1
//                        }.then { response in
//                            thenCount += 1
//                        }.then{ response in
//                            thenCount += 1
//                        }.then { response in
//                            thenCount += 1
//                        }.then { response in
//                            thenCount += 1
//                        }
//                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//                            operation.common {
//                                commonCount += 1
//                            }.then { response in
//                                //
//                            }
//                        }
//                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//                            expect(commonCount).to(equal(4))
//                            expect(thenCount).to(equal(4))
//                            done()
//                        }
//                    }
//                }
//            }
//            
//        }
//        
//    }
//    
//}
