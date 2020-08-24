import Combine
import XCTest

public class FailTests: XCTestCase {
    enum ExampleError: Error { case example }

    func test() {
        // 異常終了の経路を辿ることを検証するため
        let sink = expectation(description: "")

        let publisher = Fail(
            outputType: Void.self,
            failure: ExampleError.example
        )
        
        let _ = publisher.sink(receiveCompletion: {
            switch $0 {
            case .finished:
                XCTFail("エラーが流れなかった")
            case .failure(let error):
                XCTAssertEqual(error, ExampleError.example)
                sink.fulfill()
            }
        }, receiveValue: { _ in
            // エラーが流れるだけのため、
            // 値を受け取れていればテスト失敗にする
            XCTFail("値が流れてしまった")
        })

        wait(for: [sink], timeout: 0.01)
    }
}
