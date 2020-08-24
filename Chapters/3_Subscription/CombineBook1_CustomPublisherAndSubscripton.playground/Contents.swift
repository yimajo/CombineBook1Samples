//: Playground

import Combine

struct MyJust: Publisher {
    typealias Input = Int
    typealias Output = Int
    typealias Failure = Never

    private let value: Input

    init(value: Input) {
        self.value = value
    }

    // Publisherプロトコルのメソッド。シーケンス図のとおり
    func receive<S>(subscriber: S)
        where S : Subscriber,
        Self.Failure == S.Failure,
        Self.Output == S.Input {

        // 1.
        let subscription = MyJustSubscription(
            value: value,
            downstream: subscriber
        )

        // 2. シーケンス図
        subscriber.receive(subscription: subscription)
    }
}

final class MyJustSubscription<Downstream: Subscriber>: Subscription
    where Downstream.Input == Int {
    typealias Output = Int

    // 下流はSubscriber
    private var downstream: Downstream?
    private let value: Output

    fileprivate init(value: Output, downstream: Downstream) {
        self.downstream = downstream
        self.value = value
    }

    // 1. シーケンス図のとおり
    func request(_ demand: Subscribers.Demand) {
        // 2.
        downstream?.receive(value)
        // 3.
        downstream?.receive(completion: .finished)
    }

    // SubscriptionがCancellableに準拠している
    func cancel() {
        print("cancel:")
        downstream = nil
    }
}

let publisher = MyJust(value: 2)

let subscriber = AnySubscriber<Int, Never>(receiveSubscription: {
    print("subscription:")
    $0.request(.unlimited)
}, receiveValue: {
    print("receive:", $0)
    return .unlimited
}, receiveCompletion: {
    print("completion:", $0)
})

publisher.subscribe(subscriber)


//final class IntSubscriber: Subscriber {
//    typealias Input = Int
//    typealias Failure = Never
//
//    // 1.
//    private var subscription: Subscription?
//
//    // 2. Subscriberプロトコルのメソッドを実装する。シーケンス図のとおり
//    func receive(subscription: Subscription) {
//        self.subscription = subscription
//        subscription.request(.unlimited)
//    }
//
//    // 3. Subscriberプロトコルのメソッドを実装する。シーケンス図のとおり
//    func receive(_ input: Input) -> Subscribers.Demand {
//        return .none
//    }
//
//    // 4. Subscriberプロトコルのメソッドを実装する。シーケンス図のとおり
//    func receive(completion: Subscribers.Completion<Never>) {
//        subscription = nil
//    }
//}
