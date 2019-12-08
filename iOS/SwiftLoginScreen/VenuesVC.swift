//
//  VenuesVC.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 24/06/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import SwiftyJSON
import UIKit

class VenuesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var movieId: Int!
    var movieName: String!
    var selectLarge_picture: String!
    var selectDetails: String!
    var selectVenues_picture: String!

    deinit {
        print(#function, "\(self)")
    }

    // local
    var TableData: [datastruct] = [datastruct]()

    struct datastruct {
        var venuesId: Int!
        var name: String!
        var address: String!
        var venues_picture: String!
        var screen_screenId: String!
        var image: UIImage?

        init(add: NSDictionary) {
            venuesId = add["venuesId"] as! Int
            name = add["name"] as! String
            address = add["address"] as! String
            venues_picture = add["venues_picture"] as! String
            screen_screenId = add["screen_screenId"] as! String
        }
    }

    var refreshControl: UIRefreshControl!
    var tableView: UITableView?

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "goto_venues_details" {
            let nextSegue = segue.destination as? VenuesDetailsVC
            if let indexPath = self.tableView!.indexPathForSelectedRow {
                let data = TableData[indexPath.row]

                nextSegue?.selectVenues_picture = data.venues_picture
                nextSegue?.selectVenueId = data.venuesId
                nextSegue?.venueName = data.name
                nextSegue?.selectAddress = data.address
                nextSegue?.screen_screenId = data.screen_screenId
                nextSegue?.movieId = movieId
                nextSegue?.movieName = movieName
                nextSegue?.movieDetails = selectDetails
                nextSegue?.selectLarge_picture = selectLarge_picture
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.delegate = self
        tableView?.dataSource = self

        refreshControl = UIRefreshControl()
        tableView?.addSubview(refreshControl)

        addData()
    }

    override func viewWillAppear(_: Bool) {
        let frame: CGRect = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
        tableView = UITableView(frame: frame)
        tableView?.dataSource = self
        tableView?.delegate = self

        view.addSubview(tableView!)

        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.setTitle("Back", for: UIControl.State())
        btnNav.showsTouchWhenHighlighted = true
        btnNav.addTarget(self, action: #selector(MenuVC.navigateBack), for: UIControl.Event.touchUpInside)

        view.addSubview(btnNav)
    }

    func navigateBack() {
        dismiss(animated: true, completion: nil)
    }

    func addData() {
        let myString = String(movieId)
        var errorOnLogin: GeneralRequestManager?

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/venue/" + myString, errors: "", method: "GET", queryParameters: nil, bodyParameters: nil, isCacheable: "1", contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["venues"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        self.TableData.append(datastruct(add: dataBlock))
                    }
                }
            }

            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
            })
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
        }

        let data = TableData[indexPath.row]

        let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
        let detailText = NSMutableAttributedString(string: data.name, attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))

        cell!.textLabel?.attributedText = detailText

        if let url = URL(string: serverURL + "/simple-service-webapp/webapi/myresource" + data.venues_picture!) {
            if let imageData = try? Data(contentsOf: url) {
                cell!.imageView?.image = UIImage(data: imageData)
            }
        }

        return cell!
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return TableData.count
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        if AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue != 0 {
            performSegue(withIdentifier: "goto_venues_details", sender: self)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value) })
}
