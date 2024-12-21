//: Playground - noun: a place where people can play

import Contacts
import Foundation
import PlaygroundSupport
import UIKit
import XCPlayground

PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, playground"

// a closure that has no parameters and return a String
var hello: () -> (String) = {
    "Hello!"
}

hello() // Hello!

// a closure that take one Int and return an Int
var double: (Int) -> (Int) = { x in
    2 * x
}

double(2) // 4
var alphabet = ["a", "b", "c"]
var numbers = [1, 4, 2, 5, 8, 3]

numbers.sort(by: <) // this will sort the array in ascending order
numbers.sort(by: >) // this will sort the array in descending order
alphabet.sort(by: >)

var strings = numbers.map { "\($0)" }
print(strings)

// x always smaller than y
numbers.sort(by: { x, y in
    x < y
})

print(numbers)
// [1, 2, 3, 4, 5, 8]

numbers.sorted(by: { $0 < $1 })
numbers.sort { $0 < $1 }

var double_: (Int) -> (Int) = {
    $0 * 2
}

var sum: (Int, Int) -> (Int) = {
    $0 + $1
}

func sum(from: Int, to: Int, f: (Int) -> (Int)) -> Int {
    var sum = 0
    for i in from ... to {
        sum += f(i)
    }
    return sum
}

sum(from: 1, to: 10) {
    $0
} // the sum of the first 10 numbers

sum(from: 1, to: 10) {
    $0 * $0
} // the sum of the first 10 squares

double_(3)
sum(1, 2)

var noParameterAndNoReturnValue: () -> Void = {
    print("Hello!")
}

noParameterAndNoReturnValue()

var noParameterAndReturnValue = { () -> Int in
    1000
}

noParameterAndReturnValue()

var oneParameterAndReturnValue = { (x: Int) -> Int in
    x % 10
}

var multipleParametersAndReturnValue = {
    (first: String, second: String) -> String in

    first + " " + second
}

multipleParametersAndReturnValue("first", "second")

let numbers_ = [1, 2, 3, 4, 6, 8, 9, 3, 12, 11]

// filter numbers that devided by 3 have no remainder
let multiples = numbers_.filter { $0 % 3 == 0 }

print(multiples)

enum HTTPResponse {
    case ok
    case error(Int)
}

let lastThreeResponses: [HTTPResponse] = [.ok, .ok, .error(404)]

let hadError = lastThreeResponses.contains { element in

    if case .error = element {
        print(element)
        return true

    } else {
        print(element)
        return false
    }
}

let digitNames = [
    0: "Zero", 1: "One", 2: "Two", 3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine",
]
let numberS = [16, 58, 510]

let expenses = [21.37, 55.21, 9.32, 10.18, 388.77, 11.41]
let hasBigPurchase = expenses.contains { $0 > 100 }
// 'hasBigPurchase' == true

let strings_ = numberS.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}

// strings is inferred to be of type [String]
// its value is ["OneSix", "FiveEight", "FiveOneZero"]

let cast = ["Vivien", "Marlon", "Kim", "Karl"]
let lowercaseNames = cast.map { $0.lowercased() }

print(lowercaseNames)
// 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
let letterCounts = cast.map { $0.characters.count }

// 'letterCounts' == [6, 6, 3, 4]
