import Combine

let publisher = PassthroughSubject<Int, Never>()

_ = publisher
    .map { $0 * 2 }
    .sink {
        print($0)  // => 20
    }

publisher.send(10)
