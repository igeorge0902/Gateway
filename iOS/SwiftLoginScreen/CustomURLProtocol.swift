//
//  MyURLProtocol.swift
//  CustomURLProtocol
//
//  Created by Horatiu Potra.
//  Copyright (c) 2015 3PillarGlobal. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Realm

class CustomURLProtocol: URLProtocol, URLSessionDataDelegate, URLSessionTaskDelegate {
    fileprivate var dataTask: URLSessionDataTask?
    fileprivate var urlResponse: URLResponse?
    fileprivate var receivedData: NSMutableData?

    class var CustomKey: String {
        return "myCustomKey"
    }

    // MARK: NSURLProtocol

    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: CustomURLProtocol.CustomKey, in: request) != nil {
            return false
        }

        NSLog("Relative path for SessionDataTask==> %@", request.url!.relativePath)
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if AFNetworkReachabilityManager.shared().isReachable {
            NSLog("AFNetwork is reachable...")
            let newRequest = (request as NSURLRequest).mutableCopy() as! URLRequest

            //    NSURLProtocol.setProperty("true", forKey: CustomURLProtocol.CustomKey, inRequest: newRequest)

            let defaultConfigObj = URLSessionConfiguration.default
            let defaultSession = Foundation.URLSession(configuration: defaultConfigObj, delegate: self, delegateQueue: nil)

            dataTask = defaultSession.dataTask(with: newRequest)
            dataTask!.resume()

        } else {
            NSLog("No AFNetwork is reachable...")

            let httpVersion = "1.1"

            if let localResponse = cachedResponseForCurrentRequest(), let data = localResponse.data {
                var headerFields: [String: String] = [:]

                headerFields["Content-Length"] = String(format: "%d", data.count)

                if let mimeType = localResponse.mimeType {
                    headerFields["Content-Type"] = mimeType as String
                }

                headerFields["Content-Encoding"] = localResponse.encoding!

                let okResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: httpVersion, headerFields: headerFields)
                client?.urlProtocol(self, didReceive: okResponse!, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)

            } else {
                NSLog("AFNetwork failed to respond......")

                let failedResponse = HTTPURLResponse(url: request.url!, statusCode: 0, httpVersion: httpVersion, headerFields: nil)

                client?.urlProtocol(self, didReceive: failedResponse!, cacheStoragePolicy: .notAllowed)

                client?.urlProtocolDidFinishLoading(self)
            }
        }
    }

    override func stopLoading() {
        dataTask?.cancel()
        dataTask = nil
        receivedData = nil
        urlResponse = nil
    }

    // MARK: NSURLSessionDataDelegate

    func urlSession(_: URLSession, dataTask _: URLSessionDataTask,
                    
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        urlResponse = response
        receivedData = NSMutableData()

        completionHandler(.allow)

        NSLog("AFNetwork has received session response data from dataTask...")
    }

    func urlSession(_: URLSession, dataTask _: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)

        receivedData?.append(data)
    }

    // MARK: NSURLSessionTaskDelegate

    func urlSession(_: URLSession, task _: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            client?.urlProtocol(self, didFailWithError: error!)

            NSLog("AFNetwork error code: \(error!.localizedDescription)")

        } else {
            saveCachedResponse()
            NSLog("AFNetwork saved cahced response")

            client?.urlProtocolDidFinishLoading(self)
        }
    }

    // MARK: Private methods

    /**
     Save the current response in local storage for use when offline.
     */
    fileprivate func saveCachedResponse() {
        let realm = RLMRealm.default()
        realm.beginWriteTransaction()

        var cachedResponse = cachedResponseForCurrentRequest()

        if cachedResponse == nil {
            cachedResponse = CachedResponse()
        }

        if let data = self.receivedData {
            cachedResponse!.data = data as Data
        }

        if let url: URL = self.request.url, let absoluteString = url.absoluteString as? String {
            cachedResponse!.url = absoluteString
        }

        cachedResponse!.timestamp = Date()
        if let response = self.urlResponse {
            if let mimeType = response.mimeType {
                cachedResponse!.mimeType = mimeType as NSString
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
    fileprivate func cachedResponseForCurrentRequest() -> CachedResponse? {
        if let url: URL = self.request.url, let absoluteString = url.absoluteString as? String {
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
