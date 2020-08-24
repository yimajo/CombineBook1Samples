import Combine

let publisher = PassthroughSubject<Int, Never>()
var cancellables: Set<AnyCancellable> = []

publisher
    .handleEvents(receiveCancel: {
        print("[A] receive cancel")
    })
    .sink(receiveCompletion: {
        print($0)
    }, receiveValue: {
        print("[A] receive value: \($0)")
    })
    .store(in: &cancellables)

publisher
    .handleEvents(receiveCancel: {
        print("[B] receive cancel")
    })
    .sink(receiveCompletion: {
        print($0)
    }, receiveValue: {
        print("[B] receive value: \($0)")
    })
    .store(in: &cancellables)

publisher.send(1)
publisher.send(2)

cancellables.removeAll()

publisher.send(3)
