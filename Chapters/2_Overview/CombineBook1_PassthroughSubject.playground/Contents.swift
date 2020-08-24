import Combine

let subject = PassthroughSubject<Int, Never>()
subject.send(0)

subject.sink(receiveCompletion: {
    print("completion:", $0)
}, receiveValue: {
    print("value:", $0)
})

subject.send(1)
subject.send(2)
subject.send(3)

