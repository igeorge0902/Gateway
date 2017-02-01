//
//  r.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 18/11/15.
//  Copyright © 2015 Dipin Krishna. All rights reserved.
//

import Foundation

/// This wraps up all the response from a URL request together,
/// so it'll be easy for you to add any helpers/fields as you need it.

struct Responses {
   
    // Actual fields.
    let data: Data!
    let response: URLResponse!
    var error: NSError?
    
    // Helpers.
    var HTTPResponse: HTTPURLResponse! {
        return response as? HTTPURLResponse
    }
    
    var responseJSON: AnyObject? {
        if let data = data {
            return try! JSONSerialization.jsonObject(with: data, options: []) as AnyObject?
        } else {
            return nil
        }
    }
    
    var responseString: String? {
        if let data = data,
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return String(string)
        } else {
            return nil
        }
    }
}
