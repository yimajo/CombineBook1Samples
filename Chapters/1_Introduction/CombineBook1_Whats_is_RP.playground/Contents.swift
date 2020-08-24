//: Playground - noun: a place where people can play

import Combine

//var userBalance = 5
//let productPrice = 10

//let canMakePurchase = userBalance >= productPrice // 5 >= 10
//print(canMakePurchase) // false
//
//userBalance += 20
//print(canMakePurchase) // falseのまま
//

let userBalance = CurrentValueSubject<Int, Never>(5)
let productPrice = Just(10)

let canMakePurchase = productPrice
    .combineLatest(userBalance)
    .map { $0 <= $1 } // $0: productPrice, $1: userBalance


let cancellable = canMakePurchase
    .sink {
        print($0) // canMakePurchase はいつでも最新の状態となる
    }

userBalance.send(20)
cancellable.cancel()
