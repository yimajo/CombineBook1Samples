import Combine

class TypeWithErasedSubject {
    private let subject = PassthroughSubject<Int, Never>()

    var publisher: some Publisher {
        subject.eraseToAnyPublisher()
    }

    func foo() {
        subject.send(1)
    }
}

let typeWithErasedSubject = TypeWithErasedSubject()

if let _ = typeWithErasedSubject.publisher
    as? PassthroughSubject<Int, Never> {
    print("This line will not be executed")
}

typeWithErasedSubject.publisher.sink(receiveCompletion: { _ in
    print("TypeWithErasedSubject completed")
}, receiveValue: {
    print("TypeWithErasedSubject receive:", $0)
})

typeWithErasedSubject.foo()
