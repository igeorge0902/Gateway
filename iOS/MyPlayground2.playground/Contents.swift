//: Playground - noun: a place where people can play

import XCPlayground
import Foundation
import Contacts
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// Swift 3.0 //

var str = "Hello, playground"

let date = Date()

let timeZone = TimeZone.current.description

let current = timeZone.characters.split(separator: " ")
let zone = String(current.first!)
print(timeZone)

let dateFormatter = DateFormatter()
dateFormatter.dateStyle = DateFormatter.Style.medium
dateFormatter.timeStyle = DateFormatter.Style.short

let date_ = Date(timeIntervalSinceReferenceDate: 118800)

// US English Locale (en_US)
dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
print(dateFormatter.string(from: date_)) // Jan 2, 2001

let RFC3339DateFormatter = DateFormatter()
//RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
RFC3339DateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
RFC3339DateFormatter.timeZone = TimeZone.autoupdatingCurrent

/* 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC (Pacific Standard Time) */
let string = "2017-04-23 14:11:23 +0000" //2017-04-23 14:11:24 +0000
// "2016-12-16 00:00:00.0"
let datE = RFC3339DateFormatter.date(from: string)
print(dateFormatter.string(from: datE!)) // Jan 2, 2001

// French Locale (fr_FR)
dateFormatter.locale = Locale(identifier: "fr_FR")
print(dateFormatter.string(from: date_)) // 2 janv. 2001

// Japanese Locale (ja_JP)
dateFormatter.locale = Locale(identifier: "ja_JP")
print(dateFormatter.string(from: date_)) // 2001/01/02

let color = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
let leftMargin = 20
let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667)) // iPhone 6 proportions
view.backgroundColor = UIColor.gray

// LABEL
let label = UILabel(frame: CGRect(x: leftMargin, y: 5, width: 300, height: 44))
label.text = "Hello, playground"
label.textColor = UIColor.white
view.addSubview(label)

// TEXTFIELD
let textField = UITextField(frame: CGRect(x: leftMargin, y: 60, width: 300, height: 44))
textField.placeholder = "Edit me…"
textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
textField.textColor = UIColor.white
textField.isUserInteractionEnabled = true
view.addSubview(textField)
