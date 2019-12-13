//
//  MoviesData.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 18/06/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import Foundation
import SwiftyJSON

class MoviesData: NSObject {
    var movieId: Int!
    var movieId_: String!
    var detail: String!
    var name: String!
    var large_picture: String!
    var image: UIImageView!

    init(add: NSDictionary) {
        movieId_ = add["movieId"] as! String
        movieId = Int(movieId_)
        name = add["name"] as! String
        large_picture = add["large_picture"] as! String
        detail = add["detail"] as! String
    }

    class func addData() {
        TableData_.removeAll()

        var errorOnLogin: GeneralRequestManager?

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/movies", errors: "", method: "GET", queryParameters: nil, bodyParameters: nil, isCacheable: "0", contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["movies"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        TableData_.append(MoviesData(add: dataBlock))

                        //   dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {

                        Data.imageFromUrl(urlString: serverURL + "/simple-service-webapp/webapi/myresource" + TableData_[i].large_picture!)

                        //   })
                    }
                }
            }
        }
    }
}

extension Data {
    static func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url as URL)

            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
                (_: URLResponse?, _: Data?, _: Error?) -> Void in

                //  if let imageData = data as NSData? {
                //  self.image = UIImage(data: imageData)
                //  }
            }
        }
    }
}

extension UIAlertController {
    static func popUp(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))

        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

extension String {
    static func formatDate(date: Date) -> String {
        let dateFormatter_ = DateFormatter()
        dateFormatter_.dateStyle = DateFormatter.Style.medium
        dateFormatter_.timeStyle = DateFormatter.Style.short
        dateFormatter_.timeZone = TimeZone.autoupdatingCurrent

        // US English Locale (en_US)
        dateFormatter_.locale = Locale(identifier: "en_US_POSIX")

        return dateFormatter_.string(from: date)
    }
}

extension Date {
    static func formatDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent

        return dateFormatter.date(from: dateString)!
    }
}

extension UIViewController {
    func presentAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}
