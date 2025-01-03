//
//  HomeVC.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.

import Contacts
import CoreData
// import FacebookShare
// import FacebookLogin
// import FacebookCore
import EventKit
import SwiftyJSON
import UIKit
import WebKit
import AVKit

var selectedCalendar: String?
class VenuesDetailsVC: UIViewController, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate {
    deinit {
        screeningDateId = nil
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "navigateBack"), object: nil)
        mapview_ = nil
        print(#function, "\(self)")
    }

    lazy var NoPicture: [String: String] = Dictionary()

    let pickerdata: NSDictionary = ["screeningDatesId": 0, "screeningDate": "Select date", "movieId": 0]
    var nameTextView: UITextView?

    var selectVenues_picture: String!
    var selectLarge_picture: String!
    var selectVenueId: Int!
    var venueName: String!
    var selectAddress: String!
    var movieId: Int!
    var movieName: String!
    var movieDetails: String!
    var screen_screenId: String!
    var locationId: Int!
    var iMDB: String!

    var starty: CGFloat!
    var imageHeight: CGFloat!
    var popOverY: CGFloat!
    // var popOverX:CGFloat!

    lazy var imageView = UIImageView()
    lazy var imageView_ = UIImageView()
    var scrollView: UIScrollView!

    lazy var icons: [String: String] = Dictionary()
    lazy var googleCalendar = UIImageView()
    lazy var ical = UIImageView()
    lazy var fbShare = UIImageView()

    lazy var moviePicture = UIImage()
    lazy var venuePicture = UIImage()

    lazy var google = UIImage()
    lazy var ios = UIImage()
    lazy var fb = UIImage()

    var calendars: [EKCalendar]?
    let eventStore: EKEventStore = EKEventStore()
    var playerItemContext = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        PlacesData_.removeAll()
        icons = ["Calendar-icon": "calendar-icon", "iCal-icon": "ical", "FBShare": "facebook_share"]

        let urlString = serverURL + "/simple-service-webapp/webapi" + (selectLarge_picture!)
        
            var loadPictures: GeneralRequestManager?
            loadPictures = GeneralRequestManager(url: urlString, errors: "", method: "GET", headers: nil, queryParameters: nil, bodyParameters: nil, isCacheable: "1", contentType: "", bodyToPost: nil)
            
            
            loadPictures?.getData_ {
            (data: Data, _: NSError?) in
            let image = UIImage(data: data)
            self.moviePicture = image!
            self.moviePicture = image!

        }
        

        if (!selectVenues_picture.isEmpty) {
        
            let urlString = serverURL + "/simple-service-webapp/webapi" + (selectVenues_picture!)
        
                var loadPictures: GeneralRequestManager?
                loadPictures = GeneralRequestManager(url: urlString, errors: "", method: "GET", headers: nil, queryParameters: nil, bodyParameters: nil, isCacheable: "1", contentType: "", bodyToPost: nil)
                
                
                loadPictures?.getData_ {
                (data: Data, _: NSError?) in
                let image = UIImage(data: data)
                self.venuePicture = image!
                self.venuePicture = image!

            }
            
        } else {
        NoPicture = ["NoPicture": "cat2"]
            venuePicture = UIImage(named: NoPicture["NoPicture"]!)!
        }
        
        var imageWidth = moviePicture.size.width
        imageHeight = moviePicture.size.height

        let aspectRatio = imageWidth / imageHeight

        var startx: CGFloat = view.frame.width * 0.1
        starty = view.frame.height * 0.15

        if imageWidth > view.frame.width {
            imageWidth = view.frame.width * 0.9
            imageHeight = imageWidth / aspectRatio
            startx = view.frame.width * 0.05
        }

        var imageWidth_ = venuePicture.size.width
        var imageHeight_ = venuePicture.size.height

        let aspectRatio_ = imageWidth_ / imageHeight_

        var startx_: CGFloat = view.frame.width * 0.1
        let starty_: CGFloat = view.frame.height * 0.85

        if imageWidth_ > view.frame.width {
            imageWidth_ = view.frame.width * 0.9
            imageHeight_ = imageWidth_ / aspectRatio_
            startx_ = view.frame.width * 0.05
        }

        imageView = UIImageView(frame: CGRect(x: startx, y: starty, width: imageWidth, height: imageHeight))
        imageView.image = moviePicture

        imageView_ = UIImageView(frame: CGRect(x: startx_, y: starty_, width: imageWidth_, height: imageHeight_))
        imageView_.image = venuePicture

        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame = view.bounds
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)

        scrollView.addSubview(imageView)
        scrollView.addSubview(imageView_)

        let btnData = UIButton(frame: CGRect(x: view.frame.width / 2, y: 25, width: view.frame.width / 2, height: 20))
        btnData.backgroundColor = UIColor.black
        btnData.setTitle("Button", for: UIControl.State())
        //  btnData.addTarget(self, action: #selector(VenuesDetailsVC.dates), forControlEvents: UIControlEvents.TouchUpInside)

        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.showsTouchWhenHighlighted = true
        btnNav.setTitle("Back", for: UIControl.State())
        btnNav.addTarget(self, action: #selector(VenuesDetailsVC.navigateBack), for: UIControl.Event.touchUpInside)

        let frame1 = CGRect(x: view.frame.width * 0.15, y: (starty * 2.5) + imageHeight, width: 44, height: 20)
        let button = UIButton(frame: frame1)
        let myAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "CourierNewPS-BoldMT", size: 14.0)!]
        let title = NSMutableAttributedString(string: "Book", attributes: convertToOptionalNSAttributedStringKeyDictionary(myAttribute))

        button.tintColor = UIColor.darkGray
        button.setAttributedTitle(title, for: UIControl.State())
        button.backgroundColor = UIColor.white
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(VenuesDetailsVC.book), for: UIControl.Event.touchUpInside)
        
        let frameD = CGRect(x: view.frame.width * 0.15, y: (starty * 3) + imageHeight, width: 130, height: 20)
        let buttonD = UIButton(frame: frameD)
        let myAttributeD = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "CourierNewPS-BoldMT", size: 14.0)!]
        let titleD = NSMutableAttributedString(string: "Movie detail", attributes: convertToOptionalNSAttributedStringKeyDictionary(myAttributeD))

        buttonD.tintColor = UIColor.darkGray
        buttonD.setAttributedTitle(titleD, for: UIControl.State())
        buttonD.backgroundColor = UIColor.white
        buttonD.showsTouchWhenHighlighted = true
        buttonD.addTarget(self, action: #selector(VenuesDetailsVC.movieDetail), for: UIControl.Event.touchUpInside)

        let frame2 = CGRect(x: view.frame.width * 0.65, y: (starty * 2.5) + imageHeight, width: 44, height: 20)
        let buttonDate = UIButton(frame: frame2)
        let text: NSString = "Dates"
        let myAttributeDate = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "CourierNewPS-BoldMT", size: 14.0)!]

        // let myAttributeDate_ = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14) ]
        let titleDate = NSMutableAttributedString(string: text as String, attributes: convertToOptionalNSAttributedStringKeyDictionary(myAttributeDate))
        //titleDate.addAttributes(myAttributeDate_, range: text.range(of: text as String))

        buttonDate.tintColor = UIColor.darkGray
        buttonDate.setAttributedTitle(titleDate, for: UIControl.State())
        buttonDate.backgroundColor = UIColor.white
        buttonDate.showsTouchWhenHighlighted = true
        buttonDate.addTarget(self, action: #selector(VenuesDetailsVC.dates), for: UIControl.Event.touchUpInside)

        let frameM = CGRect(x: view.frame.width * 0.35, y: (starty * 2.5) + imageHeight, width: 44, height: 20)
        let buttonMap = UIButton(frame: frameM)
        let textM: NSString = "Map"
        let myAttributeMap = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "CourierNewPS-BoldMT", size: 14.0)!]

        // let myAttributeDate_ = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14) ]
        let titleMap = NSMutableAttributedString(string: textM as String, attributes: convertToOptionalNSAttributedStringKeyDictionary(myAttributeMap))
        //titleDate.addAttributes(myAttributeDate_, range: text.range(of: text as String))

        buttonMap.tintColor = UIColor.darkGray
        buttonMap.setAttributedTitle(titleMap, for: UIControl.State())
        buttonMap.backgroundColor = UIColor.white
        buttonMap.showsTouchWhenHighlighted = true
        buttonMap.addTarget(self, action: #selector(VenuesDetailsVC.map), for: UIControl.Event.touchUpInside)

        google = UIImage(named: icons["Calendar-icon"]!)!
        googleCalendar = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        googleCalendar.image = google

        let frame3 = CGRect(x: view.frame.width * 0.75, y: (starty * 2.9) + imageHeight, width: 44, height: 44)
        let buttonCalendar = UIButton(frame: frame3)
        buttonCalendar.setImage(googleCalendar.image, for: UIControl.State())
        buttonCalendar.showsTouchWhenHighlighted = true
        buttonCalendar.addTarget(self, action: #selector(VenuesDetailsVC.selectCalendar), for: UIControl.Event.touchUpInside)

        ios = UIImage(named: icons["iCal-icon"]!)!
        ical = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        ical.image = ios

        let frame3_ = CGRect(x: view.frame.width * 0.64, y: (starty * 2.9) + imageHeight, width: 44, height: 44)
        let buttonCalendar_ = UIButton(frame: frame3_)
        buttonCalendar_.setImage(ical.image, for: UIControl.State())
        buttonCalendar_.showsTouchWhenHighlighted = true
        buttonCalendar_.addTarget(self, action: #selector(VenuesDetailsVC.selectCalendar_), for: UIControl.Event.touchUpInside)

        fb = UIImage(named: icons["FBShare"]!)!
        fbShare = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        fbShare.image = fb

        let frame4 = CGRect(x: view.frame.width * 0.15, y: (starty * 3) + imageHeight, width: 50, height: 30)
        let buttonShare = UIButton(frame: frame4)
        buttonShare.setImage(fbShare.image, for: UIControl.State())
        buttonShare.showsTouchWhenHighlighted = true
        //     buttonShare.addTarget(self, action: #selector(VenuesDetailsVC.shareOnFaceBook), for: UIControlEvents.touchUpInside)

        // TODO: add venue details, info, etc

        let tap = UITapGestureRecognizer(target: self, action: #selector(VenuesDetailsVC.showMoreActions))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tap)
        scrollView.addSubview(button)
        scrollView.addSubview(buttonDate)
        scrollView.addSubview(buttonMap)
        scrollView.addSubview(buttonD)

        // scrollView.addSubview(buttonCalendar)
        scrollView.addSubview(buttonCalendar_)
        // scrollView.addSubview(buttonShare)
        view.addSubview(scrollView)

        view.addSubview(btnData)
        view.addSubview(btnNav)
        // self.view.addSubview(buttonCalendar)

        // create the textView
        nameTextView = UITextView(frame: CGRect(x: view.frame.size.height * 0.05, y: starty * 3.0, width: view.frame.size.width * 0.8, height: view.frame.height / 7))
        nameTextView?.isEditable = false

        let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
        let detailText = NSMutableAttributedString(string: movieDetails, attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))

        nameTextView?.attributedText = detailText
        nameTextView?.textAlignment = NSTextAlignment.justified
        nameTextView?.alwaysBounceVertical = true
        scrollView.addSubview(nameTextView!)

        //Seats
        while !SeatsData_.isEmpty {
            SeatsData_.removeAll()
        }
        ScreeningDates.removeAll()
        ScreeningDates.append(DatesData(add: pickerdata))
 
        
        guard let fileURL = Bundle.main.path(forResource: "garnier1", ofType: "mov") else {
                fatalError("File not found")
        }

        let url = NSURL.fileURL(withPath: fileURL)
        let playerItem = AVPlayerItem(asset: AVAsset(url: url), automaticallyLoadedAssetKeys: ["playable"])
        let player = AVPlayer(playerItem: playerItem)
        
        let playerFrame = CGRect(x: startx_, y: view.frame.height * 1.2, width: view.frame.width * 0.9, height: imageHeight_)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.view.frame = playerFrame

        addChild(playerViewController)
        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 55.0, right: 0.0)
        scrollView.contentSize.height = view.frame.height * 1.2 + imageHeight_
 
        scrollView.addSubview(playerViewController.view)
        playerViewController.didMove(toParent: self)
        addDatesData()
    }
    
    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "goto_map2" {
            let nextSegue = segue.destination as? MapViewController
            nextSegue?.selectVenueId = selectVenueId
            nextSegue?.map2 = true
        }
        if segue.identifier == "goto_movie_detail2" {
            let nextSegue = segue.destination as? MovieDetailVC
            nextSegue?.iMDB = iMDB
            nextSegue?.origin = "VenuesDetailsVC"
        }
    }
  
    @objc func showMoreActions(_ tap: UITapGestureRecognizer) {
        _ = tap.location(in: view)
    }

    @objc func navigateBack() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func movieDetail(_: UIButton, event: UIEvent) {
        performSegue(withIdentifier: "goto_movie_detail2", sender: self)
    }

    @objc func book(_: UIButton, event: UIEvent) {

            if event.type == .touches {
                let touches: Set<UITouch> = event.allTouches!

                if let touch = touches.first {
                    popOverY = touch.location(in: scrollView).y
                }
            }

            if screeningDateId == nil {
                let alertView: UIAlertView = UIAlertView()

                alertView.title = "Warning!"
                alertView.message = "Select dates first!"
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()

            } else {
                SelectMovieName = movieName
                SelectVenueForMovie = selectAddress
                SelectVenueName = venueName
                SelectMoviePicture = serverURL + "/simple-service-webapp/webapi" + selectLarge_picture!

                SeatsData.addData(Int(screeningDateId!)!)

                let popOver = PopOver()
                popOver.modalPresentationStyle = UIModalPresentationStyle.popover
                popOver.preferredContentSize = CGSize(width: view.frame.width * 0.90, height: view.frame.height / 2)

                let popoverMenuViewController = popOver.popoverPresentationController
                popoverMenuViewController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)

                popoverMenuViewController?.delegate = self
                popoverMenuViewController?.sourceView = view
                popoverMenuViewController!.sourceRect = CGRect(
                    x: view.frame.width * 0.50,
                    y: popOverY,
                    width: 0,
                    height: 0
                )

                present(
                    popOver,
                    animated: true,
                    completion: {
                        //   let frameM = CGRect(x: self.scrollView.frame.width * 0.35, y: 0, width: 44, height: 20)

                        //   self.scrollView.scrollRectToVisible(frameM, animated: true)
                    }
                )
            }
        
    }

    @objc func map(_: UIButton, event _: UIEvent) {
            performSegue(withIdentifier: "goto_map2", sender: self)
    }

    @objc func dates(_: UIButton, event: UIEvent) {
            if event.type == .touches {
                let touches: Set<UITouch> = event.allTouches!

                if let touch = touches.first {
                    popOverY = touch.location(in: scrollView).y
                }
            }

            let popOver = PopOverDates()
            popOver.modalPresentationStyle = UIModalPresentationStyle.popover
            popOver.preferredContentSize = CGSize(width: view.frame.width * 0.90, height: view.frame.height / 5)

            let popoverMenuViewController = popOver.popoverPresentationController
            popoverMenuViewController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)

            popoverMenuViewController?.delegate = self
            popoverMenuViewController?.sourceView = view
            popoverMenuViewController!.sourceRect = CGRect(
                x: view.frame.width * 0.50,
                y: popOverY,
                width: 0,
                height: 0
            )

            present(
                popOver,
                animated: true,
                completion: nil
            )
    }

    @objc func selectCalendar(_: UIButton) {
            if screeningDateId == nil {
                let alertView: UIAlertView = UIAlertView()

                alertView.title = "Warning!"
                alertView.message = "Select dates first!"
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()

            } else {
                // Access permission
                eventStore.requestAccess(to: EKEntityType.event) { granted, error in

                    if granted, error == nil {
                        print("permission is granted")

                        SelectMovieName = self.movieName
                        SelectVenueForMovie = self.selectAddress

                        DispatchQueue.main.async {
                            let popOver = iOSCalendarVC()
                            popOver.modalPresentationStyle = UIModalPresentationStyle.popover
                            popOver.preferredContentSize = CGSize(width: self.view.frame.width * 0.90, height: self.view.frame.height / 4)

                            let popoverMenuViewController = popOver.popoverPresentationController
                            popoverMenuViewController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                            popoverMenuViewController?.delegate = self
                            popoverMenuViewController?.sourceView = self.view
                            popoverMenuViewController!.sourceRect = CGRect(
                                x: self.view.frame.width * 0.50,
                                y: self.view.frame.height * 0.50,
                                width: 0,
                                height: 0
                            )

                            self.present(
                                popOver,
                                animated: true,
                                completion: nil
                            )
                        }
                    }
                }
            }
    }

    func presentationController(forPresented presented: UIViewController, presenting _: UIViewController?, source _: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }

    class HalfSizePresentationController: UIPresentationController {
        override var frameOfPresentedViewInContainerView: CGRect {
            return CGRect(x: 0, y: 200, width: containerView!.bounds.width, height: containerView!.bounds.height)
        }
    }

    func adaptivePresentationStyle(for _: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }

    func addDatesData() {
        var errorOnLogin: GeneralRequestManager?

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/dates/" + String(locationId) + "/" + String(movieId), errors: "", method: "GET", headers: nil, queryParameters: nil, bodyParameters: nil, isCacheable: nil, contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["dates"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        ScreeningDates.append(DatesData(add: dataBlock))
                    }
                }
            }
        }
    }

    @objc func selectCalendar_(sender _: UIButton /* , event: UIEvent */ ) {
        if screeningDateId == nil {
            let alertView: UIAlertView = UIAlertView()

            alertView.title = "Warning!"
            alertView.message = "Select dates first!"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()

        } else {
            // Access permission
            eventStore.requestAccess(to: EKEntityType.event) { granted, error in

                if granted, error == nil {
                    print("permission is granted")
                    /*
                     if event.type == .touches {

                     let touches:Set<UITouch> = event.allTouches!

                     if let touch =  touches.first{

                     self.popOverY = touch.location(in: self.scrollView).y
                     self.popOverX = touch.location(in: self.view).x

                     }
                     }*/

                    SelectMovieName = self.movieName
                    SelectVenueForMovie = self.selectAddress
                    DispatchQueue.main.async {
                        let popOver = iOSCalendarVC()
                        popOver.modalPresentationStyle = UIModalPresentationStyle.popover
                        popOver.preferredContentSize = CGSize(width: self.view.frame.width * 0.90, height: self.view.frame.height / 4)

                        let popoverMenuViewController = popOver.popoverPresentationController
                        popoverMenuViewController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                        popoverMenuViewController?.delegate = self
                        popoverMenuViewController?.sourceView = self.view
                        popoverMenuViewController!.sourceRect = CGRect(
                            x: self.view.frame.width * 0.50,
                            y: self.view.frame.height * 0.50,
                            width: 0,
                            height: 0
                        )

                        self.present(
                            popOver,
                            animated: true,
                            completion: nil
                        )
                    }
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
private func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value) })
}
