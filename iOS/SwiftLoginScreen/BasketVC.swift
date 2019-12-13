//
//  Basket.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 2017. 04. 26..
//  Copyright © 2017. George Gaspar. All rights reserved.
//

import Foundation
// import Braintree
// import BraintreeDropIn
import SwiftyJSON
// import FacebookCore

/**
 Stores BasketData objects representing basket items.
 */
var BasketData_ = [Int: BasketData]()
class BasketVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    deinit {
        tableView_?.reloadData()
        print(#function, "\(self)")
    }

    var collectionView: UICollectionView!
    lazy var token = "sandbox_dpdzm97y_j3ndqpzrhy4gp2p7"

    var ResponseText: String?
    var ResponseCode: String?
    var AuthCode: String?
    var Status: String?
    var Amount: String?
    var TaxAmount: String?
    var movieName: String?

    lazy var values = [BasketData](BasketData_.values)
    lazy var layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.showsTouchWhenHighlighted = true
        btnNav.setTitle("Back", for: UIControl.State.normal)
        btnNav.addTarget(self, action: #selector(BasketVC.navigateBack), for: UIControl.Event.touchUpInside)

        let btnData = UIButton(frame: CGRect(x: view.frame.width / 2, y: 25, width: view.frame.width / 2, height: 20))
        btnData.backgroundColor = UIColor.black
        btnData.setTitle("CheckOut", for: UIControl.State())
        btnData.showsTouchWhenHighlighted = true
        btnData.addTarget(self, action: #selector(BasketVC.book), for: UIControl.Event.touchUpInside)

        view.addSubview(btnNav)
        view.addSubview(btnData)

        layout.sectionInset = UIEdgeInsets(top: 55, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width * 0.9, height: view.frame.width * 0.5)

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(FeedCells.self, forCellWithReuseIdentifier: "FeedCell")
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)

        view.addSubview(collectionView)
        view.sendSubviewToBack(collectionView)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
    }

    @objc func navigateBack() {
        dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if BasketData_.count > 0 {
            return BasketData_.count
        }

        return 0
    }

    func collectionView(_: UICollectionView, shouldHighlightItemAt _: IndexPath) -> Bool {
        return true
    }

    func collectionView(_: UICollectionView, shouldSelectItemAt _: IndexPath) -> Bool {
        return true
    }

    func collectionView(_: UICollectionView, canPerformAction _: Selector, forItemAt _: IndexPath, withSender _: Any?) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //   let cell = collectionView.cellForItem(at: indexPath)

        let seatId = values[indexPath.row].seatId!
        let seatData = [NSDictionary](Seats.values)
        let seatNr = values[indexPath.row].seats_seatNumber
        let screeningDateId = values[indexPath.row].screeningDateId

        seatData.forEach { item in

            _ = item.contains { (_, value) -> Bool in

                if (value as! String) == screeningDateId {
                    for (keys, values) in item {
                        if (keys as! String) == "seat" {
                            if (values as! String).contains(seatNr! + "-") {
                                let str = (values as AnyObject).replacingOccurrences(of: seatNr! + "-", with: "")

                                let seat = ["screeningDateId": screeningDateId, "seat": str]

                                Seats.updateValue(seat as NSDictionary, forKey: screeningDateId!)

                                let seatDatas = [NSDictionary](Seats.values)
                                seatDatas.forEach { item in
                                    _ = item.contains { (_, value) -> Bool in
                                        for (keys, values) in item {
                                            if (keys as! String) == "seat" {
                                                if !(values as! String).contains("-") {
                                                    Seats.removeValue(forKey: value as! String)
                                                }
                                            }
                                        }
                                        return true
                                    }
                                }
                            }

                            BasketData_.removeValue(forKey: seatId)
                            return true
                        }
                    }
                }

                return false
            }
        }
        seatsToBeReserved.removeValue(forKey: seatId)
        values.remove(at: indexPath.row)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCells

        cell.textLabel?.text = values[indexPath.row].movie_name
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false

        let paragrapStyle = NSMutableParagraphStyle()
        paragrapStyle.lineSpacing = 4

        let title = NSMutableAttributedString(string: (cell.textLabel?.text!)!, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 14.0)!]))

        title.append(NSAttributedString(string: "\n\(values[indexPath.row].venue_name!)", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 12.0)!, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(red: 155 / 255, green: 161 / 255, blue: 171 / 255, alpha: 1)])))

        title.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapStyle, range: NSMakeRange(0, title.string.characters.count))

        // TODO: add map pointing to the venue
        let icon = NSTextAttachment()
        icon.image = UIImage(named: "Shit Hits Fan-25")
        icon.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)

        title.append(NSAttributedString(attachment: icon))

        cell.textLabel?.attributedText = title

        if let urlMovie = URL(string: values[indexPath.row].movie_picture) {
            print(values[indexPath.row].movie_picture)
            if let movieImage = try? Data(contentsOf: urlMovie) {
                cell.profileImage?.image = UIImage(data: movieImage)
            }
        }

        let text = NSMutableAttributedString(string: "Ticket details: \n Seat Row: \(values[indexPath.row].seats_seatRow!), \n Seat Nr: \(values[indexPath.row].seats_seatNumber!), \nDate of Screening: \n\(values[indexPath.row].screening_date!)", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 14.0)!]))

        cell.statusText?.attributedText = text

        return cell
    }

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt _: IndexPath) {}

    /**
     Calls the func checkOutWithCards() to initiate the checking out process.

     @return
     */
    @objc func book() {
        if BasketData_.count < 1 {
            UIAlertController.popUp(title: "Warning!", message: "Select free seat(s) first!")

        } else {
            // TODO: check if user has active session
            postNonceToServer("hello")
        }
    }

    func postNonceToServer(_ paymentMethodNonce: String) {
        let seatData = [NSDictionary](Seats.values)
        let testdata: NSDictionary = ["seatsToBeReserved": seatData]
        let test: Data = try! JSONSerialization.data(withJSONObject: testdata, options: [])
        let data = NSString(data: test, encoding: String.Encoding.utf8.rawValue)! as String
        let time = zeroTime(0).getCurrentMillis()
        let hmacSHA512 = CryptoJS.hmacSHA512()
        // Create a clean alpha-numeric (length shall match the specs of BrainTree API) orderId - invoice nr - as the hash result of current time and paymentMethodNonce.
        let orderId: NSString = hmacSHA512.hmac(String(time), secret: paymentMethodNonce as String) as NSString
        // post data. The server will use this data to reproduce the hash
        // when saving nonce to vault then send the current time as X-MICRO-TIME header
        let post: NSString = "payment_method_nonce=\(paymentMethodNonce)&seatsToBeReserved=\(data)&orderId=\(time)" as NSString
        let postData: Data = post.data(using: String.Encoding.ascii.rawValue)!

        var errorOnLogin: GeneralRequestManager?
        errorOnLogin = GeneralRequestManager(url: serverURL + "/login/CheckOut", errors: "", method: "POST", queryParameters: nil, bodyParameters: nil, isCacheable: nil, contentType: contentType_.urlEncoded.rawValue, bodyToPost: postData)

        errorOnLogin?.getResponse {
            (json: JSON, error: NSError?) in
            // TODO: add error cases
            if error != nil {
            } else {
                if let list = json["seatsforscreen"].object as? NSArray {
                    SeatsData_.removeAll()
                    for i in 0 ..< list.count {
                        if let dataBlock = list[i] as? NSDictionary {
                            SeatsData_.append(SeatsData(add: dataBlock))
                        }
                    }
                }
                if let list = json["tickets"].object as? NSArray {
                    print(json)
                    for i in 0 ..< list.count {
                        if let dataBlock = list[i] as? NSDictionary {
                            let ticketId = "ticketId_" + String(i)
                            TicketsData_.append(TicketsData(add: dataBlock))
                            tickets.updateValue(String(TicketsData_[i].ticketId), forKey: ticketId)
                        }
                    }
                }
                if let responseText = json["ResponseText"].string {
                    // success case
                    if responseText == "hello" {
                        // let ResponseCode = json["ResponseCode"].string
                        // let AuthCode = json["AuthCode"].string
                        let Status = json["Status"].string
                        let Amount = json["Amount"].rawValue
                        let TaxAmount = json["TaxAmount"].rawValue

                        UIAlertController.popUp(title: "Payment info:", message: "ResponseText: \(responseText), Status: \(Status!), Amount: \(Amount), TaxAmount: \(TaxAmount), Movie name: \(TicketsData_[0].movie_name!), \(tickets.minimalDescrption)")

                        TicketsData_.removeAll()
                        tickets.removeAll()
                        Seats.removeAll()
                        BasketData_.removeAll()
                        self.collectionView.reloadData()
                    }

                } else if let responseText = json["Error"].string {
                    // error case
                    print(json)
                    if let list = json["failedTickets"].object as? NSArray {
                        for i in 0 ..< list.count {
                            if let dataBlock = list[i] as? NSDictionary {
                                TicketsData_.append(TicketsData(add: dataBlock))
                            }
                        }
                    }

                    let Status = json["Success"].string!
                    UIAlertController.popUp(title: "Booking failed with payment info:", message: "Failed tickets for movie: \(TicketsData_[0].movie_name!), seats_seatNumber: \(TicketsData_[0].seats_seatNumber!), ResponseText: \(responseText), Status: \(Status))")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
