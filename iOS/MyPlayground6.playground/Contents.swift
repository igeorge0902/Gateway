//: Playground - noun: a place where people can play

import PlaygroundSupport
import UIKit

PlaygroundPage.current.needsIndefiniteExecution = true

let text: NSString = "Dates"
let myAttributeDate = [NSAttributedString.Key.font: UIFont(name: "CourierNewPS-BoldMT", size: 14.0)!]
let myAttributeDate_ = [NSAttributedString.Key.font: UIFont.fontNames(forFamilyName: "Courier New")]

let titleDate = NSMutableAttributedString(string: text as String, attributes: myAttributeDate)

/*
 class LabelViewController : UIViewController {

 override func loadView() {

     // UI

     let view = UIView()
     view.backgroundColor = .white

     let label = UILabel()
     label.text = "Hello world!"

     view.addSubview(label)

     // Layout

     label.translatesAutoresizingMaskIntoConstraints = false
     NSLayoutConstraint.activate([
         label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
         label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         ])

     self.view = view
 }

 }
 */
