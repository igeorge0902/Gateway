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
    let data: NSData!
    let response: NSURLResponse!
    var error: NSError?
    
    // Helpers.
    var HTTPResponse: NSHTTPURLResponse! {
        return response as? NSHTTPURLResponse
    }
    
    var responseJSON: AnyObject? {
        if let data = data {
            return try? NSJSONSerialization.JSONObjectWithData(data, options: [])
        } else {
            return nil
        }
    }
    
    var responseString: String? {
        if let data = data,
            string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return String(string)
        } else {
            return nil
        }
    }
}