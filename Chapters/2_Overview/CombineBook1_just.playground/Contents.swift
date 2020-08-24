//: Playground - noun: a place where people can play

import Combine

let publisher = Just(1)
publisher.sink(receiveCompletion: {
    print("completion:", $0) // completion: finished
}, receiveValue: {
    print("value:", $0) // value: 1
})
