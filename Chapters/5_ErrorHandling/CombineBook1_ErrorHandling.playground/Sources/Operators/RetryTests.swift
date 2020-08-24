import Combine
import XCTest

public class RetryTests: XCTestCase {
    enum ExampleError: Error { case example }

    func testリトライによりエラーを流さない() {
        // 値の処理と正常終了の経路を辿ることを検証のため
        let sink = expectation(description: "")
        sink.expectedFulfillmentCount = 2
        // リトライによりsubscriptionの2回実行を検証のため
        let subscription = expectation(description: "")
        subscription.expectedFulfillmentCount = 2

        // 最初のtryMapだけ必ず失敗させるためのフラグ
        var isFirstTry = true

        let _ = "A".publisher
            .handleEvents(receiveSubscription: { aValue in
                subscription.fulfill()
            })
            .tryMap { (arg: Character) -> Character in
                if isFirstTry {
                    // 最初だけ失敗させるため
                    // よいやり方ではないが
                    // 2回目以降は失敗しないようなフラグ変更
                    isFirstTry = false
                    throw ExampleError.example
                }

                return arg
            }
            .retry(1) // 1回だけ再試行
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    sink.fulfill()
                case .failure:
                    XCTFail("エラーが流れ異常終了してしまった")
                }
            }, receiveValue: {
                XCTAssertEqual($0, "A")
                sink.fulfill()
            })

        wait(for: [sink, subscription], timeout: 0.01)
    }
}
