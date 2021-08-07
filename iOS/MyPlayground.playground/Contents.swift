//: Playground - noun: a place where people can play

import Cocoa
import Contacts
import Foundation
import PlaygroundSupport
import XCPlayground

PlaygroundPage.current.needsIndefiniteExecution = true

var myDateString: [String.SubSequence]?

var str = "Hello, playground"

var string = str.split(separator: " ")

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
let w = Double(x) * y

var int = 10
int -= 1
print(int)

let testdata: [String: Any] = [
    "venue": "Urania Filmszinház"
]

let test: Data = try! JSONSerialization.data(withJSONObject: testdata, options: [])
let data = NSString(data: test, encoding: String.Encoding.utf8.rawValue)! as String
let post: NSString = "newScreen=\(data)" as NSString
let postData: Data = post.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)!

let str_ = String(decoding: postData, as: Unicode.UTF8.self)

print(str_)

enum HTTPResponse {
    case ok
    case error(Int)
}

var responses: [String] = ["Cinema City Allee Park", "Cinema City Campona", "Cinema City Mom Park"]
responses.sort { ($0) > ($1)}
responses
responses = responses.filter { $0.contains("Park")}


print(responses)
//print(returnResponse)
