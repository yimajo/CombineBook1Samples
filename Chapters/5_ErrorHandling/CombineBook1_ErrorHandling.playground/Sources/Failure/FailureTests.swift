import Combine
import XCTest

public class FailuerTests: XCTestCase {
    enum ExampleError: Error { case example }

    func testSink() {
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 2

        let _ = (1..<100).publisher
//            .handleEvents(receiveOutput: {
//                print("handleEventsA:", $0)
//            })
            .flatMap { arg -> AnyPublisher<Int, ExampleError> in
                // 値が2になると異常終了させるようにし、
                // それ以外はJustで別のストリームに切り替える。
                if arg == 2 {
                    return Fail(
                        outputType: Int.self,
                        failure: ExampleError.example
                    )
                    .eraseToAnyPublisher()
                } else {
                    return Just(arg)
                        .setFailureType(to: ExampleError.self)
                        .eraseToAnyPublisher()
                }
            }
//            .handleEvents(receiveOutput: {
//                print("handleEventsB:", $0)
//            })
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    XCTFail("エラーが流れず正常終了してしまった")
                case .failure(let error):
                    XCTAssertEqual(error, ExampleError.example)
                    exp.fulfill()
                }
            }, receiveValue: {
                // 1のみが流れていることを検証
                XCTAssertEqual($0, 1) // 5.
                exp.fulfill()
            })

        wait(for: [exp], timeout: 0.01)
    }
}
