//
//  Downloader.swift
//  MyFirstSwiftApp
//
//  Created by Gaspar Gyorgy on 18/07/15.
//  Copyright (c) 2015 Gaspar Gyorgy. All rights reserved.
//

import Foundation
import Realm
import SwiftyJSON
// import Kanna

let serverURL = "https://milo.crabdance.com"
enum contentType_: String {
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
    case image = "image/jpeg"
}
class GeneralRequestManager: NSObject {

    fileprivate var urlResponse: URLResponse?
    
    var url: URL!
    var errors: String!
    var method: String!
    var queryParameters: [String: String]?
    var headers: [String: String]?
    var bodyParameters: [String: String]?
    var isCacheable: String?
    var contentType: String!
    var bodyToPost: Data?

    var prefs: UserDefaults = UserDefaults.standard

    init?(url: String, errors: String, method: String, headers: [String: String]?, queryParameters: [String: String]?, bodyParameters: [String: String]?, isCacheable: String?, contentType: String, bodyToPost: Data?) {
        super.init()
        self.url = URL(string: url)!
        self.errors = errors
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.isCacheable = isCacheable
        self.contentType = contentType
        self.bodyToPost = bodyToPost
        if url.isEmpty {}
        if errors.isEmpty {}
    }

    deinit {
        NSLog("\(url!) is being deinitialized")
        NSLog("\(errors!) is being deinitialized")
        NSLog(#function, "\(self)")
    }

    lazy var session: URLSession = URLSession.sharedCustomSession
    var running = false

    func getData_(_ onCompletion: @escaping (Data, NSError?) -> Void) {
        dataTask_ { data, err in

            onCompletion(data as Data, err)
        }
    }
    
    func getData(_ onCompletion: @escaping (JSON, NSError?) -> Void) {
        if isCacheable == "1" {
                 if let localResponse = cachedResponseForCurrentRequest(), let data = localResponse.data {
                     if localResponse.timestamp.addingTimeInterval(3600) > Date() {
                         var headerFields: [String: String] = [:]

                         headerFields["Content-Length"] = String(format: "%d", data.count)

                         if let mimeType = localResponse.mimeType {
                             headerFields["Content-Type"] = mimeType as String
                         }

                         headerFields["Content-Encoding"] = localResponse.encoding!
                         let err: NSError = NSError()

                         let json: JSON = try! JSON(data: data)

                         onCompletion(json as JSON, err)

                     } else {
                         dataTask { json, err in

                             onCompletion(json as JSON, err)
                         }

                         let realm = RLMRealm.default()
                         realm.beginWriteTransaction()
                         realm.delete(localResponse)

                         do {
                             try realm.commitWriteTransaction()
                         } catch {
                             print("Something went wrong!")
                         }
                     }

                 } else {
                     dataTask { json, err in

                         onCompletion(json as JSON, err)
                     }
                 }

             } else {
                 dataTask { json, err in

                     onCompletion(json as JSON, err)
                 }
             }
    }
    
    func getResponse(_ onCompletion: @escaping (JSON, NSError?) -> Void) {
        if isCacheable == "1" {
            if let localResponse = cachedResponseForCurrentRequest(), let data = localResponse.data {
                if localResponse.timestamp.addingTimeInterval(3600) > Date() {
                    var headerFields: [String: String] = [:]

                    headerFields["Content-Length"] = String(format: "%d", data.count)

                    if let mimeType = localResponse.mimeType {
                        headerFields["Content-Type"] = mimeType as String
                    }

                    headerFields["Content-Encoding"] = localResponse.encoding!
                    let err: NSError = NSError()

                    let json: JSON = try! JSON(data: data)

                    onCompletion(json as JSON, err)

                } else {
                    dataTask { json, err in

                        onCompletion(json as JSON, err)
                    }

                    let realm = RLMRealm.default()
                    realm.beginWriteTransaction()
                    realm.delete(localResponse)

                    do {
                        try realm.commitWriteTransaction()
                    } catch {
                        print("Something went wrong!")
                    }
                }

            } else {
                dataTask { json, err in

                    onCompletion(json as JSON, err)
                }
            }

        } else {
            dataTask { json, err in

                onCompletion(json as JSON, err)
            }
        }
    }
    
    // for testing
    func dataTask_(_ onCompletion: @escaping (Data, NSError?) -> Void) {

        let request = URLRequest.requestWithURL(url, method: method, queryParameters: queryParameters, bodyParameters: bodyParameters as NSDictionary?, headers: headers, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30, isCacheable: isCacheable, contentType: contentType, bodyToPost: bodyToPost)

            let task = session.dataTask(with: request, completionHandler: { data, response, sessionError -> Void in
            
            //let json: JSON = try! JSON(data: data!)
                onCompletion(data!, sessionError as NSError?)

            })
            task.resume()
    }

    // INFO: use this class for every dataTask operation
    func dataTask(_ onCompletion: @escaping ServiceResponses) {
        // TODO: temp solution
        var xtoken = prefs.value(forKey: "X-Token")
        if xtoken == nil {
            xtoken = ""
        }
        if url.absoluteString.contains(serverURL) {
            headers = ["Ciphertext": xtoken as! String, "X-Token": "client-secret", "X-Device": deviceId as String]
        }

        let request = URLRequest.requestWithURL(url, method: method, queryParameters: queryParameters, bodyParameters: bodyParameters as NSDictionary?, headers: headers, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30, isCacheable: "", contentType: contentType, bodyToPost: bodyToPost)

        let task = session.dataTask(with: request, completionHandler: { data, response, sessionError -> Void in
            //  if  let json:JSON = try! JSON(data: data!) {
            var error = sessionError

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    let description = "HTTP response was \(httpResponse.statusCode)"

                    error = NSError(domain: "Custom", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
                    NSLog(error!.localizedDescription)
                }
            }

            if error != nil {
                if data == nil {
                    UIAlertController.popUp(title: "Error:", message: error!.localizedDescription + ", empty response")

                } else {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 503 {
                            if let result = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as? String {
                                // if let doc = Kanna.HTML(html: result, encoding: String.Encoding.ascii) {

                                //        UIAlertController.popUp(title: "Error:", message: doc.title!)
                                //     }
                            }

                        } else {
                            UIAlertController.popUp(title: "Error:", message: error!.localizedDescription)
                        }
                    }
                }

            } else {
                // let json: AnyObject! = try?NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                if let httpResponse = response as? HTTPURLResponse {
                    NSLog("got a " + String(httpResponse.statusCode) + " response code")
                }

                if self.isCacheable == "1" {
                    self.saveCachedResponse(data!)
                }

                let json: JSON = try! JSON(data: data!)

                if json["Email was sent to:"].string != nil {
                    UIAlertController.popUp(title: "Hello!", message: json.rawString()!)

                } else {
                    NSLog("Hey, You, what's that sound?")
                }

                self.running = false
                onCompletion(json, error as NSError?)
            }
        })

        running = true
        task.resume()
    }

    /**
     Save the current response in local storage for use when offline.
     */
    fileprivate func saveCachedResponse(_ data: Data) {
        let realm = RLMRealm.default()
        realm.beginWriteTransaction()

        var cachedResponse = cachedResponseForCurrentRequest()

        if cachedResponse == nil {
            cachedResponse = CachedResponse()
        }

        // if let data_:Data = data {
        cachedResponse!.data = data
        // }

        if let url: URL? = url, let absoluteString = url?.absoluteString {
            cachedResponse!.query = queryParameters?.values.first
            cachedResponse!.url = absoluteString
        }

        cachedResponse!.timestamp = Date()
        if let response = self.urlResponse {
            if let mimeType = response.mimeType {
                cachedResponse!.mimeType = mimeType as NSString!
            }

            if let encoding = response.textEncodingName {
                cachedResponse!.encoding = encoding
            }
        }

        realm.add(cachedResponse!)

        do {
            try realm.commitWriteTransaction()
        } catch {
            print("Something went wrong!")
        }
    }

    /**
     Gets a cached response from local storage if there is any.

     :returns: A CachedResponse optional object.
     */
    func cachedResponseForCurrentRequest() -> CachedResponse? {
        
        if let url: URL? = url, let absoluteString = url?.absoluteString, let query = queryParameters?.values.first {
            let p: NSPredicate = NSPredicate(format: "query == %@", argumentArray: [query])

            // Query
            let results = CachedResponse.objects(with: p)
            if results.count > 0 {
                return results.object(at: 0) as? CachedResponse
            }
        } else if let url: URL? = url, let absoluteString = url?.absoluteString {
            let p: NSPredicate = NSPredicate(format: "url == %@", argumentArray: [absoluteString])

            // Query
            let results = CachedResponse.objects(with: p)
            if results.count > 0 {
                return results.object(at: 0) as? CachedResponse
            }
        }

        return nil
    }
}

