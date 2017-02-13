UseCase
=======

Use case library.

Use case base class to use `.then` and `.catch` after execute.

Any use case subclass must be initialized with a **OperationQueue**.
This class executes the code under an **Operation**, this means that UseCase can be suspended, or cancelled.

## How use it.
Create a class or struct implementing UseCaseRequest and other UseCaseResponse

Then create a subclass of UseCase<Request, Response> with yours UseCaseRequest and UseCaseResponse.
Override the main method, this receives a operation object. When your code finish, set operation.response or operation.error to end the execution of your code.

## Example:

```swift

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

//Using TestUseCase:
useCase.execute(TestRequest()).common {
    print("Im finished.")
}
.then { response in
    print("With response \(response)")
}
.catch { (error) in
    print("With error \(error)")
}



```

## Contributing:
If you find and issue, please, write a test that reproduce it and notificate me by github issues.
If you have some idea about how to improve it, fork it, write your code, test it and send me a pull request.

## Developed by:

[Julián Alonso](https://twitter.com/maisterJuli).

## LICENSE:
Apache 2.0 license. See [`LICENSE`](LICENSE) file for details
