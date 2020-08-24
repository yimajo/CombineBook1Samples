//: Playground - noun: a place where people can play

import Combine

let subscriber = AnySubscriber<Int, Never>(receiveSubscription: {
    print("subscription:")
    $0.request(.unlimited)
}, receiveValue: {
    print("receive:", $0)
    return .unlimited
}, receiveCompletion: {
    print("completion:", $0)
})


let publisher = Just(1)
publisher.subscribe(subscriber)
