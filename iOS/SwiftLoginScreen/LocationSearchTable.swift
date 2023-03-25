//
//  LocationSearchTable.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 2021. 08. 10..
//  Copyright © 2021. George Gaspar. All rights reserved.
//

import UIKit
import MapKit
class LocationSearchTable : UITableViewController {

    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
  //  var tableView: UITableView?


    override func viewDidLoad() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        
        let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        cell.detailTextLabel?.text = address
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
       // PlacesData_[indexPath.row].mapItem().placemark
        dismiss(animated: true, completion: nil)
    }
}

extension LocationSearchTable : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
    guard let mapView = mapView,
    
    let searchBarText = searchController.searchBar.text else {
        return }
    
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
    
    let search = MKLocalSearch(request: request)
        search.start { [self] response, _ in
    
            guard let response = response else {
                return }
    
            /*
             
             PlacesData_.removeAll()
             let pathString = "locations"

             var errorOnLogin: GeneralRequestManager?

             errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/" + pathString, errors: "", method: "GET", headers: nil, queryParameters: nil, bodyParameters: nil, isCacheable: "", contentType: "", bodyToPost: nil)

             errorOnLogin?.getResponse {
                 (json: JSON, _: NSError?) in

                 //   PlacesData_.removeAll()

                 if let list = json["locations"].object as? NSArray {
                     for i in 0 ..< list.count {
                         if let dataBlock = list[i] as? NSDictionary {
                             if let location = PlacesData.fromJSON(dataBlock) {
                                 PlacesData_.append(location)
                                }
                            }
                        }
                    }
                 }
             }
            
             for i in 0 ..< PlacesData_.count {
             if PlacesData_[i].title.contains(searchBarText) {
                if let item = PlacesData_[i] as PlacesData? {
                    matchingItems.append(item.mapItem())
                    }
                }
            }
            */
            
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}
