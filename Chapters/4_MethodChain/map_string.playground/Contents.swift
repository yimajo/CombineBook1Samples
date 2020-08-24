import Combine

let publisher = PassthroughSubject<Int, Never>()

publisher
    .map { (arg: Int) -> String in
        "value: \(arg)"
    }
    .sink { (arg: String) -> Void in
        print(arg)  // => "value: 10"
    }

publisher.send(10)
