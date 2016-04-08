//
//  RegEx.swift
//  
//
//  Created by Gaspar Gyorgy on 05/09/15.
//  Copyright (c) 2015 Gaspar Gyorgy. All rights reserved.
//

import Foundation

class RegEx {
    
    func containsMatch(pattern: String, inString string: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSMakeRange(0, string.characters.count)
        return regex?.firstMatchInString(string, options: [], range: range) != nil
    }
    
    func replaceMatches(pattern: String, inString string: String, withString replacementString: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSMakeRange(0, string.characters.count)
        
        return regex?.stringByReplacingMatchesInString(string, options: [], range: range, withTemplate: replacementString)
    }
    
}