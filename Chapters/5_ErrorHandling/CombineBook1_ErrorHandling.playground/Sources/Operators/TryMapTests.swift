import Combine
import XCTest

public class TryMapTests: XCTestCase {
    enum ExampleError: Error { case example }

    func test() {
        // 異常終了の経路を辿ることを検証するため
        let sink = expectation(description: "")
        sink.expectedFulfillmentCount = 1

        // 結果の値を格納する配列を用意しておく
        var temp: [Int] = []

        let _ = (1..<100).publisher
            .tryMap { (arg: Int) -> Int in
                // 3の場合にエラーをthrowするようにし、
                // そこで異常終了させるようにする
                if arg == 3 {
                    throw ExampleError.example
                }

                return arg
            }
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    XCTFail("エラーが流れず正常終了してしまった")
                case .failure(let error):
                    // tryMapはエラーをthrowしてしまうため、
                    // Outputで指定していないエラーが流れる。
                    // つまりErrorに準拠するすべてが対象となるため、
                    // キャストする必要がある。
                    XCTAssertEqual(
                        error as? ExampleError,
                        ExampleError.example
                    )
                    sink.fulfill()
                }
            }, receiveValue: {
                // 値を最後1回で比較するため
                temp.append($0)
            })

        // 値が3の場合にエラーになるため、
        // 結果は3未満の値が格納されていることを検証する
        XCTAssertEqual(temp, [1, 2]) //
        wait(for: [sink], timeout: 0.01)
    }
}
