//
//  Time.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 28/12/15.
//  Copyright © 2015 George Gaspar. All rights reserved.
//

import Foundation
import UIKit

typealias zeroTime = (Int64)
//let currentTime = zeroTime(0).getCurrentMillis()

extension Int64 {
    
     func getCurrentMillis()->Int64{
        
        let time = Int64(Date().timeIntervalSince1970 * 1000)

        return  time
    }
    
}

extension Sequence {
    var minimalDescrption: String {
        return map { String(describing: $0) }.joined(separator: " ")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
