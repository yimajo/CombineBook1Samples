import Combine
import XCTest

public class ReplaceErrorTests: XCTestCase {
    enum ExampleError: Error { case example }

    func testエラーを置き換える() {
        let sink = expectation(description: "")
        sink.expectedFulfillmentCount = 2

        let publisher = Fail(
            outputType: String.self,
            failure: ExampleError.example
        )

        let _ = publisher
            .replaceError(with: "X")
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    // 正常終了することを検証
                    sink.fulfill()
                case .failure:
                    XCTFail("エラーが流れてしまい異常終了")
                }
            }, receiveValue: {
                // エラーを文字Xに置き換えたことを検証
                XCTAssertEqual($0, "X")
                sink.fulfill()
            })

        wait(for: [sink], timeout: 0.01)
    }

    func testリトライと組み合わせる() {
        let sink = expectation(description: "")
        sink.expectedFulfillmentCount = 1

        // 結果を格納するための配列
        var temp: [Int] = []

        let _ = (1..<100).publisher
            .tryMap { (arg: Int) -> Int in
                if arg == 3 {
                    // 3になるとエラーにする
                    throw ExampleError.example
                }

                return arg
            }
            .retry(1) // 1回リトライさせそれ以上のエラーは
            .replaceError(with: 0) // 0に置き換える
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    sink.fulfill()
                case .failure:
                    XCTFail("エラーが流れてしまい異常終了")
                }
            }, receiveValue: {
                temp.append($0)
            })

        // 1回リトライするので1, 2と繰り返すが
        // リトライ時も3になるとエラーになる。
        // catchによりそのエラーを0に置き換えている。
        XCTAssertEqual(temp, [1, 2, 1, 2, 0])
        wait(for: [sink], timeout: 0.01)
    }
}


