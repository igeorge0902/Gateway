//
//  TicketsVC.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 2017. 09. 16..
//  Copyright © 2017. George Gaspar. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 Stores BasketData objects representing basket items.
 */
class TicketsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    deinit {
        purchaseId = nil
        CollectionData.removeAll()
        print(#function, "\(self)")
    }

    var collectionView: UICollectionView!

    var ResponseText: String?
    var ResponseCode: String?
    var AuthCode: String?
    var Status: String?
    var Amount: String?
    var TaxAmount: String?
    var movieName: String?
    var purchaseId: String!

    lazy var filter = CIFilter(name: "CIQRCodeGenerator")

    var CollectionData: [AllTicketsData] = [AllTicketsData]()
    lazy var layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        addData()

        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.showsTouchWhenHighlighted = true
        btnNav.setTitle("Back", for: UIControl.State.normal)
        btnNav.addTarget(self, action: #selector(TicketsVC.navigateBack), for: UIControl.Event.touchUpInside)

        view.addSubview(btnNav)

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
        collectionView.reloadData()
    }

    @objc func navigateBack() {
        dismiss(animated: true, completion: nil)
    }

    func addData() {
        var errorOnLogin: GeneralRequestManager?

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/purchases/tickets", errors: "", method: "GET", headers: nil, queryParameters: ["purchaseId": purchaseId], bodyParameters: nil, isCacheable: "0", contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["tickets"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        self.CollectionData.append(AllTicketsData(add: dataBlock))
                    }
                }
            }
        }

        if collectionView != nil {
            collectionView.reloadData()
        }
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if CollectionData.count > 0 {
            return CollectionData.count
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

    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {}

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCells

        cell.textLabel?.text = CollectionData[indexPath.row].movie_name
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false

        let paragrapStyle = NSMutableParagraphStyle()
        paragrapStyle.lineSpacing = 4

        let title = NSMutableAttributedString(string: (cell.textLabel?.text!)!, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 14.0)!]))

        title.append(NSAttributedString(string: "\n\(CollectionData[indexPath.row].movie_name!)", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 12.0)!, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(red: 155 / 255, green: 161 / 255, blue: 171 / 255, alpha: 1)])))

        title.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapStyle, range: NSMakeRange(0, title.string.count))

        // TODO: add map pointing to the venue
        let icon = NSTextAttachment()
        icon.image = UIImage(named: "Shit Hits Fan-25")
        icon.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)

        title.append(NSAttributedString(attachment: icon))

        cell.textLabel?.attributedText = title

        if let urlMovie = URL(string: serverURL + "/simple-service-webapp/webapi/myresource" + CollectionData[indexPath.row].movie_picture) {
            if let movieImage = try? Data(contentsOf: urlMovie) {
                cell.profileImage?.image = UIImage(data: movieImage)
            }
        }

        let text = NSMutableAttributedString(string: "Ticket details: \n Seat Row: \(CollectionData[indexPath.row].seats_seatRow!), \n Seat Nr: \(CollectionData[indexPath.row].seats_seatNumber!), \nDate of Screening: \n\(CollectionData[indexPath.row].screening_date!), \n Venue: \(CollectionData[indexPath.row].venue_name!)", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 14.0)!]))

        cell.statusText?.attributedText = text

        guard let filter = filter,
            let data = CollectionData[indexPath.row].seats_seatNumber!.data(using: .isoLatin1, allowLossyConversion: false) else {
            return cell
        }

        filter.setValue(data, forKey: "inputMessage")
        let ciImage = filter.outputImage
        cell.QRCodeImage?.image = UIImage(ciImage: ciImage!, scale: 4.0, orientation: .up)

        return cell
    }

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt _: IndexPath) {}

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
