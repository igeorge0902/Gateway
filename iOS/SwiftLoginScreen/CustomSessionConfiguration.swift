//
//  n.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 18/11/15.
//  Copyright © 2015 Dipin Krishna. All rights reserved.
//

import Foundation

extension NSURLSessionConfiguration {
    
    /// Just like defaultSessionConfiguration, returns a newly created session configuration object, customised
    /// from the default to your requirements.
    class func CustomSessionConfiguration() -> NSURLSessionConfiguration {
        
        let config = defaultSessionConfiguration()
        
        config.timeoutIntervalForRequest = 10 // Make things timeout quickly.
        config.HTTPAdditionalHeaders = ["MyResponseType": "JSON"] // My web service needs to be explicitly asked for JSON.
        config.HTTPShouldUsePipelining = true // Might speed things up if your server supports it.
        
        return config
    }
    
}