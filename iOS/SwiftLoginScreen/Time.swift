//
//  Time.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 28/12/15.
//  Copyright © 2015 George Gaspar. All rights reserved.
//

import Foundation

typealias zeroTime = (Int64)
//let currentTime = zeroTime(0).getCurrentMillis()

extension Int64 {
    
     func getCurrentMillis()->Int64{
        
        let time = Int64(NSDate().timeIntervalSince1970 * 1000)

        return  time
    }
    
}