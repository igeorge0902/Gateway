//
//  PlacesData.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 26/06/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//
//

import AddressBook
import Foundation
import MapKit
import SwiftyJSON

class PlacesData: NSObject, MKAnnotation {
    // Place structure
    let locationId: Int!
    let title: String?
    let locationName: String
    let type: String
    let coordinate: CLLocationCoordinate2D

    init(locationId: Int, title: String, locationName: String, type: String, coordinate: CLLocationCoordinate2D) {
        self.locationId = locationId
        self.title = title
        self.locationName = locationName
        self.type = type
        self.coordinate = coordinate

        super.init()
    }

    class func fromJSON(_ json: NSDictionary) -> PlacesData! {
        let locationId = json.value(forKey: "locationId") as! Int
        let title = json.value(forKey: "name") as! String
        let locationName = json.value(forKey: "formatted_address") as! String
        let type = "movie_theater" as String
        /*
         guard let geometry = json.valueForKey("geometry"),
             let location = geometry.valueForKey("location") else { return nil }
         */
        let latitude = json.value(forKey: "latitude") as! Double
        let longitude = json.value(forKey: "longitude") as! Double
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        return PlacesData(locationId: locationId, title: title, locationName: locationName, type: type, coordinate: coordinate)
    }

    var subtitle: String? {
        return locationName
    }

    var locationId_: Int? {
        return locationId
    }

    // MARK: - MapKit related methods

    // pinColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    func pinColor() -> MKPinAnnotationColor {
        switch type {
        case "movie_theater":
            return .red
        case "beauty_salon":
            return .purple
        default:
            return .green
        }
    }

    // annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        // decorate the map with the appended Artwork structure items
        let addressDict = [String(kABPersonAddressStreetKey): self.subtitle! as String]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        // mapItem.phoneNumber = String(self.locationId)

        return mapItem
    }
}
