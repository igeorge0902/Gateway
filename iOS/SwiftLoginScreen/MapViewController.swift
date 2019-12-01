//
//  ViewController.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 26/06/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import UserNotifications

var PlacesData_:Array< PlacesData > = Array < PlacesData >()
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    deinit {
        
        PlacesData_.removeAll()
        print(#function, "\(self)")
    }
    
    var icons:Dictionary<String, String> = Dictionary()
    var imageView: UIImageView!
    var locationManager: CLLocationManager!
    var locationId_: Int!
    var selectVenueId: Int!
    var map2:Bool?
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        
        // user activated automatic authorization info mode
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined || status == .denied {
        
            DispatchQueue.main.async(execute: { () -> Void in
                
                // present an alert indicating location authorization required
                let message = "\(status)\n\nPlease allow the app to access your location through the Settings."
                self.showMessage(message)

            })

        }
        
        locationManager!.startUpdatingLocation()
        locationManager!.startUpdatingHeading()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.standard
        //mapView.userTrackingMode = .follow
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
            mapView.showsScale = true
            mapView.showsTraffic = true
            mapView.showsCompass = true
            mapView.showsBuildings = true
            mapView.showsUserLocation = true
            mapView.isScrollEnabled = true

        
        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: self.view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.setTitle("Back", for: UIControl.State())
        btnNav.showsTouchWhenHighlighted = true
        btnNav.addTarget(self, action: #selector(MenuVC.navigateBack), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(btnNav)
        
        self.addData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        mapView.addAnnotations(PlacesData_)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let location = self.locationManager.location
        centerMapOnLocation(location!)
        mapView.centerCoordinate = location!.coordinate
                
    }
    
    // instantiate Artwork class
    var artworks = [PlacesData]()

    func navigateBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addData() {
        
        var pathString = ""
        var queryString:[String : String]?
        if (selectVenueId == nil) {
            pathString = "locations"
        } else {
            pathString = "locations/venue"
            queryString = ["venuesId" : String(selectVenueId!)]
        }
        
        var errorOnLogin:GeneralRequestManager?

        errorOnLogin = GeneralRequestManager(url: "https://milo.crabdance.com/mbooks-1/rest/book/" + pathString, errors: "", method: "GET", queryParameters: queryString , bodyParameters: nil, isCacheable: "", contentType: "", bodyToPost: nil)
        
        errorOnLogin?.getResponse {
            
            (json: JSON, error: NSError?) in
            
         //   PlacesData_.removeAll()
            
            if let list = json["locations"].object as? NSArray {
            
                for i in 0 ..< list.count {
                    
                    if let dataBlock = list[i] as? NSDictionary {
                                           
                        if let artwork = PlacesData.fromJSON(dataBlock) {
                            
                            PlacesData_.append(artwork)

                                }

                        }

                    }

            } else {
            
            let locationId = json["locationId"].int
            let formatted_address = json["formatted_address"].string
            let name = json["name"].string
            let latitude = json["latitude"].rawValue
            let longitude = json["longitude"].rawValue

            let venuePlaceData:NSDictionary = ["locationId" : locationId!, "formatted_address" : formatted_address!, "name" : name!, "latitude" : latitude, "longitude" : longitude]
            
            
                        if let artwork = PlacesData.fromJSON(venuePlaceData) {
                            
                            PlacesData_.append(artwork)
                            
                        }
            }
            
            self.mapView.addAnnotations(PlacesData_)
            
        }
    }
    
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                                  latitudinalMeters: regionRadius * 1.0, longitudinalMeters: regionRadius * 1.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if let annotation = annotation as? PlacesData {
            
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                
                // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
                
            } else {
                
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.animatesDrop = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                
                icons = ["About":"about", "CircleRight" : "circled_right"]

                let arrowButton = UIButton() as UIView

                arrowButton.frame.size.width = 44
                arrowButton.frame.size.height = 44

                let icon:UIImage? = UIImage(named: icons["CircleRight"]!)
                imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: icon!.size.width, height: icon!.size.height));
                imageView.image = icon;
                
                arrowButton.addSubview(imageView)
                
                view.rightCalloutAccessoryView = arrowButton
                
                /*
                 let button : UIButton = UIButton(type: .System) as UIButton
                 button.addTarget(self, action:#selector(self.showActionSheetTapped), forControlEvents: UIControlEvents.TouchUpInside)
                 */
                
                if map2 == false {
                
                let infoButton = UIButton() as UIView
                
                infoButton.frame.size.width = 44
                infoButton.frame.size.height = 44
                
                let icon_:UIImage? = UIImage(named: icons["About"]!)
                imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: icon_!.size.width, height: icon_!.size.height));
                imageView.image = icon_;

                infoButton.addSubview(imageView)
                
                view.leftCalloutAccessoryView = infoButton
                
                }
                
            }
            
            view.pinColor = annotation.pinColor()
            
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        if #available(iOS 9.0, *) {
        } else {
            // Fallback on earlier versions
        }
        
        if map2 == false {

        if control == view.leftCalloutAccessoryView {
            
            if AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue != 0 {

            let location = view.annotation as! PlacesData
            locationId_ = location.locationId
            control.isHighlighted = true
            control.isSelected = true
            self.showActionSheetTapped()
                
                }
            
            }
        }
        
        if control == view.rightCalloutAccessoryView {
            
            let location = view.annotation as! PlacesData
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMaps(launchOptions: launchOptions)
            
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        //  self.showActionSheetTapped()
        print("hello")
    }
    
    /*
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
     
        mapView.centerCoordinate = userLocation.location!.coordinate
     
    }*/
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateToLocations newLocations: CLLocation, fromLocation oldLocation: CLLocation) {
        print("present location : \(newLocations.coordinate.latitude), \(newLocations.coordinate.longitude)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        NSLog("Entering region")
    
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        NSLog("Exit region")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goto_venues_for_movies" {
            let nextSegue = segue.destination as? VenueForMoviesVC
            
                nextSegue!.locationId = locationId_
            
        }
    }
    
    func showActionSheetTapped() {
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Choose an option!", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Go to Venue", style: .default) { action -> Void in
            
            self.performSegue(withIdentifier: "goto_venues_for_movies", sender: self)
            //Code for launching the camera goes here
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .default) { action -> Void in
            //Code for picking from camera roll goes here
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func showMessage(_ message: String) {
        // Create an Alert
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        
        // Add an OK button to dismiss
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) -> Void in
        }
        alertController.addAction(dismissAction)
        
        // Show the Alert
        self.present(alertController, animated: true, completion: nil)
    }

    
    // MARK: - location manager to authorize user location for Maps app
    //  var locationManager = CLLocationManager()
    //  func checkLocationAuthorizationStatus() {
    //    if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
    //      mapView.showsUserLocation = true
    //    } else {
    //      locationManager.requestWhenInUseAuthorization()
    //    }
    //  }
    //  
    //  override func viewDidAppear(animated: Bool) {
    //    super.viewDidAppear(animated)
    //    checkLocationAuthorizationStatus()
    //  }
    
}

