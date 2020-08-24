import Combine
import XCTest

public class MapErrorTests: XCTestCase {
    enum ExampleError: Error { case example }
    enum OtherError: Error { case example }

    func testエラーを他のエラーにして異常終了() {
        let sink = expectation(description: "")
        sink.expectedFulfillmentCount = 1

        let publisher = Fail(
            outputType: Void.self,
            failure: ExampleError.example
        )

        let _ = publisher
            .mapError { error -> OtherError in
                OtherError.example
            }
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    XCTFail("正常終了してしまった")
                case .failure(let error):
                    XCTAssertEqual(error, OtherError.example)
                    sink.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("値を受け取ってはいけない")
            })

        wait(for: [sink], timeout: 0.01)
    }
}
