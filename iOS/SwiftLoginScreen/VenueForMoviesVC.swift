//
//  VenueForMovies.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 14/08/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import SwiftyJSON
import UIKit

var ScreeningDates: [DatesData] = [DatesData]()
class VenueForMoviesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    deinit {
        print(#function, "\(self)")
    }

    var venuesId: Int!
    var selectDetails: String!
    var venues_picture: String!
    var locationId: Int!

    var TableData: [MoviesData] = [MoviesData]()
    var searchController: UISearchController!
    var shouldShowSearchResults = false

    var running = false

    // local
    var VenueData: [datastruct] = [datastruct]()

    struct datastruct {
        var venuesId: Int!
        var name: String!
        var address: String!
        var venues_picture: String!
        var screen_screenId: String!
        var image: UIImage?

        init(add: NSDictionary) {
            venuesId = (add["venuesId"] as! Int)
            name = (add["name"] as! String)
            address = (add["address"] as! String)
            venues_picture = (add["venues_picture"] as! String)
            screen_screenId = (add["screen_screenId"] as! String)
        }
    }

    var refreshControl: UIRefreshControl!
    var tableView: UITableView?

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "goto_venues_details2" {
            let nextSegue = segue.destination as? VenuesDetailsVC
            if let indexPath = self.tableView!.indexPathForSelectedRow {
                let data = TableData[indexPath.row]
                let venueData = VenueData[indexPath.row]

                nextSegue?.selectVenues_picture = venueData.venues_picture
                nextSegue?.selectVenueId = venueData.venuesId
                nextSegue?.venueName = venueData.name
                nextSegue?.movieId = data.movieId
                nextSegue?.movieName = data.name
                nextSegue?.movieDetails = data.detail
                nextSegue?.selectLarge_picture = data.large_picture
                nextSegue?.iMDB = data.imdb
                nextSegue?.locationId = locationId

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.delegate = self
        tableView?.dataSource = self

        refreshControl = UIRefreshControl()
        tableView?.addSubview(refreshControl)

        // Initialize and set up the search controller

        searchController = UISearchController(searchResultsController: nil)

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search in Title and Description..."
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.searchBarStyle = .minimal
        definesPresentationContext = true

        searchController.searchBar.sizeToFit()

        let searchBarFrame = UIView(frame: CGRect(x: 0.0, y: 50, width: view.frame.width, height: 44))
        searchBarFrame.addSubview(searchController.searchBar)
        view.addSubview(searchBarFrame)

        addData()
        // self.addDatesData()
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
        btnNav.addTarget(self, action: #selector(VenueForMoviesVC.navigateBack), for: UIControl.Event.touchUpInside)

        view.addSubview(btnNav)
    }

    @objc func navigateBack() {
        dismiss(animated: true, completion: nil)
    }

    func addData() {
        TableData.removeAll()
        VenueData.removeAll()

        var errorOnLogin: GeneralRequestManager?

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/venue/movies", errors: "", method: "GET", headers: nil, queryParameters: ["locationId": String(locationId)], bodyParameters: nil, isCacheable: nil, contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["movies"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        self.TableData.append(MoviesData(add: dataBlock))
                    }
                }
            }

            if let list = json["venue"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        self.VenueData.append(datastruct(add: dataBlock))
                    }
                }
            }

            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
            })
        }
    }

    func addDatesData() {
        var errorOnLogin: GeneralRequestManager?

        errorOnLogin = GeneralRequestManager(url: "https://milo.crabdance.com/mbooks-1/rest/book/dates/" + String(2) + "/" + String(1002), errors: "", method: "GET", headers: nil, queryParameters: nil, bodyParameters: nil, isCacheable: nil, contentType: "", bodyToPost: nil)

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

    func searchBarTextDidBeginEditing(_: UISearchBar) {
        shouldShowSearchResults = true
        tableView!.reloadData()
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        shouldShowSearchResults = false
        tableView!.reloadData()
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView!.reloadData()
        }

        searchController.searchBar.resignFirstResponder()
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text

        // TODO: call API for fulltextSearch
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
        }

        let data = TableData[indexPath.row]

        cell!.textLabel?.text = data.name
        let url = URL(string: serverURL + "/simple-service-webapp/webapi/myresource" + data.large_picture!)
        let imageData = try? Data(contentsOf: url!)

        cell!.imageView?.image = UIImage(data: imageData!)

        return cell!
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return TableData.count
    }

    func tableView(_: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        performSegue(withIdentifier: "goto_venues_details2", sender: self)
    }
}
