//: Playground - noun: a place where people can play

import Combine

let subject = CurrentValueSubject<Int, Never>(-1)

subject.send(0)

subject.sink(receiveCompletion: {
    print("completion:", $0)
}, receiveValue: {
    print("value:", $0)
})

subject.send(1)
subject.send(2)
subject.send(3)

