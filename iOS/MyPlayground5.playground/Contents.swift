//: Playground - noun: a place where people can play

import Contacts
import Foundation
import PlaygroundSupport
import UIKit
import XCPlayground

PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, playground"

let seat = ["screeningDateId": "3", "seat": "A3-A1-"]
let seat_ = ["screeningDateId": "2", "seat": "A1-"]

var Seats = [String: NSDictionary]()
Seats.updateValue(seat as NSDictionary, forKey: "3")
Seats.updateValue(seat_ as NSDictionary, forKey: "2")
let seatData = [NSDictionary](Seats.values)
let testdata_: NSDictionary = ["seatsToBeReserved": seatData]

// print(seatData)

var splittedString: [String.SubSequence]?
var splittedString_: [String.SubSequence]?

// find matching seatIds for a screeningDateId
var key_: String?
var value_: String?
var item_: NSDictionary?
var boolean_: Bool?
var booleanocska: Bool?

// forEach on NSDictionay Array [NSDictionary]
seatData.forEach { item in

    print(item.allValues)

    boolean_ = item.contains { (key, value) -> Bool in

        print(key, value)
        if (value as! String) == "3" {
            print(value)
            for (keys, values) in item {
                print(keys, values)

                if (keys as! String) == "seat" {
                    print(keys, values)
                    if (values as! String).contains("A3-") {
                        print(values)
                        str = (values as AnyObject).replacingOccurrences(of: "A3-A1-", with: "")
                        print(str)
                        let seat = ["screeningDateId": "3", "seat": str]
                        Seats.updateValue(seat as NSDictionary, forKey: "3")
                        let seatDatas = [NSDictionary](Seats.values)
                        print("seatDatas: \(seatDatas)")

                        seatDatas.forEach { item in

                            print("All values: \(item.allValues)")

                            booleanocska = item.contains { (key, value) -> Bool in

                                print("key: \(key), value: \(value)")

                                for (keys, values) in item {
                                    if (keys as! String) == "seat" {
                                        if !(values as! String).contains("-") {
                                            print("keys: \(keys), values: \(values)")

                                            Seats.removeValue(forKey: value as! String)
                                        }
                                    }
                                }
                                return true
                            }
                        }
                    }

                    print("key: \(keys), value: \(values)")
                    print("Seats: \(str)")

                    return true
                }
            }
        }

        return false
    }
}

let seatData_ = [NSDictionary](Seats.values)
let testdata: NSDictionary = ["seatsToBeReserved": seatData_]

JSONSerialization.isValidJSONObject(testdata)

let test: Data = try! JSONSerialization.data(withJSONObject: testdata, options: [])

let jsonData: NSDictionary = try JSONSerialization.jsonObject(with: test, options:

    JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary

let data = NSString(data: test, encoding: String.Encoding.utf8.rawValue)! as String

print(data)
