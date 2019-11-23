//
//  VenueForMovies.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 14/08/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import UIKit
import SwiftyJSON

var ScreeningDates:Array< DatesData > = Array < DatesData >()
class VenueForMoviesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    deinit {
        print(#function, "\(self)")
    }
        
    var venuesId:Int!
    var selectDetails:String!
    var venues_picture:String!
    var locationId: Int!
    
    var TableData:Array< MoviesData > = Array < MoviesData >()
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    
    var running = false
    
    // local
    var VenueData:Array< datastruct > = Array < datastruct >()
    
    struct datastruct
    {
        var venuesId:Int!
        var name:String!
        var address:String!
        var venues_picture:String!
        var screen_screenId:String!
        var image:UIImage? = nil
        
        
        init(add: NSDictionary)
        {
            venuesId = add["venuesId"] as! Int
            name = add["name"] as! String
            address = add["address"] as! String
            venues_picture = add["venues_picture"] as! String
            screen_screenId = add["screen_screenId"] as! String
        }
    }
    
    var refreshControl: UIRefreshControl!
    var tableView:UITableView?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goto_venues_details2" {
            
            let nextSegue = segue.destination as? VenuesDetailsVC
            if let indexPath = self.tableView!.indexPathForSelectedRow {
                
                let data = TableData[indexPath.row]
                let venueData = VenueData[0]
                
                nextSegue?.selectVenues_picture = venueData.venues_picture
                nextSegue?.selectVenueId = venueData.venuesId
                nextSegue?.movieId = data.movieId
                nextSegue?.movieDetails = data.detail
                nextSegue?.selectLarge_picture = data.large_picture
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        refreshControl = UIRefreshControl()
        self.tableView?.addSubview(self.refreshControl)
        
        // Initialize and set up the search controller
        
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search in Title and Description..."
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.searchBarStyle = .minimal
        self.definesPresentationContext = true
        
        searchController.searchBar.sizeToFit()
        
        let searchBarFrame = UIView(frame: CGRect(x: 0.0, y: 50, width: self.view.frame.width, height: 44))
        searchBarFrame.addSubview(searchController.searchBar)
        self.view.addSubview(searchBarFrame);
        
        self.addData()
        //self.addDatesData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let frame:CGRect = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height-100)
        self.tableView = UITableView(frame: frame)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        self.view.addSubview(self.tableView!)
        
        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: self.view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.setTitle("Back", for: UIControl.State())
        btnNav.showsTouchWhenHighlighted = true
        btnNav.addTarget(self, action: #selector(MenuVC.navigateBack), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(btnNav)
    }
    
    
    func navigateBack() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func addData() {
        
        TableData.removeAll()
        VenueData.removeAll()
        
        var errorOnLogin:GeneralRequestManager?
        
        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/venue/movies", errors: "", method: "GET", queryParameters: ["locationId": String(locationId)], bodyParameters: nil, isCacheable: nil, contentType: "", bodyToPost: nil)
        
        errorOnLogin?.getResponse {
            
            (json: JSON, error: NSError?) in
            
            if let list = json["movies"].object as? NSArray
            {
                for i in 0 ..< list.count
                {
                    if let dataBlock = list[i] as? NSDictionary
                    {
                        
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
        
        var errorOnLogin:GeneralRequestManager?
        
        errorOnLogin = GeneralRequestManager(url: "https://milo.crabdance.com/mbooks-1/rest/book/dates/"+String(2)+"/"+String(1002), errors: "", method: "GET", queryParameters: nil, bodyParameters: nil, isCacheable: nil, contentType: "", bodyToPost: nil)
        
        errorOnLogin?.getResponse {
            
            (json: JSON, error: NSError?) in
            
            if let list = json["dates"].object as? NSArray
            {
                for i in 0 ..< list.count
                {
                    if let dataBlock = list[i] as? NSDictionary
                    {
                        
                        ScreeningDates.append(DatesData(add: dataBlock))
                    }
                }
                
            }
            
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        self.tableView!.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tableView!.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tableView!.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        // TODO: call API for fulltextSearch
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
   
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "goto_venues_details2", sender: self)
        
    }
    
}
