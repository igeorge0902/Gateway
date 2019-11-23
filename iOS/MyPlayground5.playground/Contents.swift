//: Playground - noun: a place where people can play

import XCPlayground
import Foundation
import Contacts
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, playground"

let seat = ["screeningDateId": "3", "seat": "A3-A1-"]
let seat_ = ["screeningDateId": "2", "seat": "A1-"]

var Seats = [String:NSDictionary]()
Seats.updateValue(seat as NSDictionary, forKey: "3")
Seats.updateValue(seat_ as NSDictionary, forKey: "2")
let seatData = [NSDictionary](Seats.values)
let testdata_:NSDictionary = ["seatsToBeReserved": seatData]

//print(seatData)

var splittedString:[String.CharacterView.SubSequence]?
var splittedString_:[String.CharacterView.SubSequence]?

// find matching seatIds for a screeningDateId
var key_:String?
var value_:String?
var item_:NSDictionary?
var boolean_:Bool?
var booleanocska:Bool?


// forEach on NSDictionay Array [NSDictionary]
seatData.forEach { item in
    
    print(item.allValues)
    
    boolean_ = item.contains {  (key, value) -> Bool in
        
        print(key,value)
        if (value as! String) == "3" {

            print(value)
            for (keys, values) in item {
                
                print(keys,values)

                if ((keys as! String) == "seat") {
                    
                    print(keys, values)
                    if ((values as! String).contains("A3-")) {
                    
                        print(values)
                    str = (values as AnyObject).replacingOccurrences(of: "A3-", with: "")

                        print(str)
                        let seat = ["screeningDateId": "3", "seat": str]

                        Seats.updateValue(seat as NSDictionary, forKey: "3")
                    }
                    
                    print("key: \(keys), value: \(values)")
                    
    
                    
                    
                    print ("Seats: \(str)")
                    
                    return true
                    
                    }
                }
            
            
            }

            return false
        }
}



let seatData_ = [NSDictionary](Seats.values)
let testdata:NSDictionary = ["seatsToBeReserved": seatData_]

JSONSerialization.isValidJSONObject(testdata)

let test:Data = try! JSONSerialization.data(withJSONObject: testdata, options: [])

let jsonData:NSDictionary = try JSONSerialization.jsonObject(with: test, options:
    
    JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary

let data = NSString(data: test, encoding: String.Encoding.utf8.rawValue)! as String

print(data)

let numberWords = ["one", "two", "three"]
for word in numberWords {
    print(word)
}
// Prints "one"
// Prints "two"
// Prints "three"

numberWords.forEach { word in
    print(word)
}

let name = "Marie Curie"
let firstSpace = name.characters.index(of: " ")!
let firstName = String(name.characters.prefix(upTo: firstSpace))
print(firstName)