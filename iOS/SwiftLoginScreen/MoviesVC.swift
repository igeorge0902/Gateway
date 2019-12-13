//
//  Movies.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 30/05/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import SwiftyJSON
import UIKit
// import FacebookCore
// import FacebookShare

var TableData_: [MoviesData] = [MoviesData]()
class MoviesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    deinit {
        print(#function, "\(self)")
    }

    var SearchData: [MoviesData] = [MoviesData]()
    var TableData: [MoviesData] = [MoviesData]()
    var data: MoviesData?
    var searchController: UISearchController!
    var shouldShowSearchResults = false

    /*
     struct datastruct
     {
         var movieId:Int!
         var detail:String!
         var name:String!
         var large_picture:String!
         var image:UIImage? = nil

         init(add: NSDictionary)
         {
             movieId = add["movieId"] as! Int
             name = add["name"] as! String
             large_picture = add["large_picture"] as! String
             detail = add["detail"] as! String
         }
     }*/

    var refreshControl: UIRefreshControl!
    var tableView: UITableView?

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "goto_venues" {
            let nextSegue = segue.destination as? VenuesVC

            if let indexPath = self.tableView!.indexPathForSelectedRow {
                var data = TableData[indexPath.row]

                nextSegue!.movieId = data.movieId
                nextSegue!.movieName = data.name
                nextSegue!.selectDetails = data.detail
                nextSegue!.selectLarge_picture = data.large_picture

                if SearchData.count > 0 {
                    data = SearchData[indexPath.row]

                    nextSegue!.movieId = data.movieId
                    nextSegue!.movieName = data.name
                    nextSegue!.selectDetails = data.detail
                    nextSegue!.selectLarge_picture = data.large_picture
                }
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
        btnNav.addTarget(self, action: #selector(MoviesVC.navigateBack), for: UIControl.Event.touchUpInside)

        view.addSubview(btnNav)
    }

    @objc func navigateBack() {
        dismiss(animated: true, completion: nil)
    }

    func addData() {
        TableData.removeAll()

        var errorOnLogin: GeneralRequestManager?

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/movies", errors: "", method: "GET", queryParameters: nil, bodyParameters: nil, isCacheable: "1", contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["movies"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        self.TableData.append(MoviesData(add: dataBlock))
                    }
                }
            }

            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
            })
        }
    }

    func addData_(_ match: String) {
        var errorOnLogin: GeneralRequestManager?

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/movies/search", errors: "", method: "GET", queryParameters: ["match": match], bodyParameters: nil, isCacheable: nil, contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["searchedMovies"].object as? NSArray {
                self.SearchData.removeAll()
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        self.SearchData.append(MoviesData(add: dataBlock))
                    }
                }
            }

            if let _ = json["NotFoundMovies"].object as? NSArray {
                // TODO: present empty list
            }

            //  if self.SearchData.count > 0 {

            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()

            })

            //  }
        }
    }

    func searchBarTextDidBeginEditing(_: UISearchBar) {
        shouldShowSearchResults = false
        // self.tableView!.reloadData()
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        shouldShowSearchResults = false
        searchController.searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_: UISearchBar) {
        shouldShowSearchResults = true
    }

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        if searchText.substring(from: searchText.startIndex).count > 2 {
            // NSObject.cancelPreviousPerformRequests(withTarget: self)
            // self.perform(#selector(MoviesVC.addData_(_:)), with: searchText, afterDelay: 0.5)

            //  let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 0 * Int64(NSEC_PER_SEC))
            //  dispatch_after(time, dispatch_get_main_queue()) {

            let backgroundQueue = DispatchQueue.global()
            let deadline = DispatchTime.now() + .milliseconds(100)
            backgroundQueue.asyncAfter(deadline: deadline, qos: .background) {
                self.addData_(searchText)
            }

            //      AppEventsLogger.log(AppEvent.searched(contentId: nil, searchedString: searchText, successful: true, valueToSum: 1, extraParameters: ["":""]))

            //  }
        }

        if searchText.substring(from: searchText.startIndex).count == 0 {
            SearchData.removeAll()
            tableView!.reloadData()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        print(searchString!)
    }

    func searchDisplayController(_: UISearchController, shouldReloadTableForSearchString _: NSString) {}

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let control = UISegmentedControl(items: ["Reset", "NA", "NA"])
        control.backgroundColor = UIColor.darkGray
        control.addTarget(self, action: #selector(MoviesVC.valueChanged(_:)), for: UIControl.Event.valueChanged)

        if section == 0 {
            return control
        }

        return nil
    }

    @objc func valueChanged(_ segmentedControl: UISegmentedControl) {
        print("Coming in : \(segmentedControl.selectedSegmentIndex)")
        if segmentedControl.selectedSegmentIndex == 0 {
            SearchData.removeAll()
        } else if segmentedControl.selectedSegmentIndex == 1 {
        } else if segmentedControl.selectedSegmentIndex == 2 {}
        tableView!.reloadData()
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 22.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
        }

        if TableData_.count > 0 {
            data = TableData_[indexPath.row]

        } else if TableData.count > 0 {
            data = TableData[indexPath.row]
        }

        if SearchData.count > 0 {
            data = SearchData[indexPath.row]
        }

        let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
        let detailText = NSMutableAttributedString(string: (data?.name)!, attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))

        cell!.textLabel?.attributedText = detailText
        // TODO: pictures' size shall not exceed 100 kbytes
        if let url = URL(string: serverURL + "/simple-service-webapp/webapi/myresource" + (data?.large_picture)!) {
            if let imageData = try? Data(contentsOf: url) {
                cell!.imageView?.image = UIImage(data: imageData)
            }
        }
        //  cell.imageView?.image = TableData[indexPath.row].image

        return cell!
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if SearchData.count > 0 {
            return SearchData.count
        }

        return TableData.count
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        //  searchController.searchBar.resignFirstResponder()

        if AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue != 0 {
            performSegue(withIdentifier: "goto_venues", sender: self)
        }
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt _: IndexPath) {}

    func scrollViewDidScroll(_: UIScrollView) {}
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
