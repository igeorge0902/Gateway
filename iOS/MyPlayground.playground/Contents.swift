//: Playground - noun: a place where people can play

import Cocoa
import XCPlayground
import Foundation
import Contacts
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var myDateString:[String.CharacterView.SubSequence]?

var str = "Hello, playground"

var string = str.characters.split(separator: " ")

var s = string.prefix(10)

let characters = Array(string)

string.map { (number) -> String in

    print(number.first!)
    return ""
}

print(String(string.first!))
s.count
string.startIndex

let x = 5
let y = 1.25
let w = Double(x)*y