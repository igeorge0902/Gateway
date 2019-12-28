//
//  n.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 18/11/15.
//  Copyright © 2015 Dipin Krishna. All rights reserved.
//

import Foundation

extension URLSessionConfiguration {
    /// Just like defaultSessionConfiguration, returns a newly created session configuration object, customised
    /// from the default to your requirements.
    class func CustomSessionConfiguration() -> URLSessionConfiguration {
        let config = `default`

        // config.timeoutIntervalForRequest = 20 // Make things timeout quickly.
        config.sessionSendsLaunchEvents = true
        // My web service needs to be explicitly asked for JSON.
        config.httpAdditionalHeaders = ["MyResponseType": "JSON"]
        // Might speed things up if your server supports it.
        config.httpShouldUsePipelining = true

        return config
    }
}
