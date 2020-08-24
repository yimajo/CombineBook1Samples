import Combine

let publisher = PassthroughSubject<Int, Never>()

let cancellable = publisher
    .handleEvents(receiveCancel: {
        print("receive cancel")
    })
    .sink(receiveCompletion: {
        // 正常終了でも異常終了でもないため出力されない
        print($0)
    }, receiveValue: {
        print($0)
    })

publisher.send(1)
publisher.send(2)

cancellable.cancel()

// 以降の要素は処理されない
publisher.send(3)
