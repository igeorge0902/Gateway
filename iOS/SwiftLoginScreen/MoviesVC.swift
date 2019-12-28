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
var endOfFile = false
var veil = true
var shouldShowSearchResults = false
class MoviesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    deinit {
        endOfFile = false
        TableData.removeAll()
        print(#function, "\(self)")
    }

    var SearchData: [MoviesData] = [MoviesData]()
    var TableData: [MoviesData] = [MoviesData]()
    var data: MoviesData?
    var searchController: UISearchController!
    lazy var session = URLSession.sharedCustomSession


    var refreshControl: UIRefreshControl!
    var tableView: UITableView?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goto_venues" {
            let nextSegue = segue.destination as? VenuesVC

            if let indexPath = self.tableView!.indexPathForSelectedRow {
                var data = TableData[indexPath.row]

                nextSegue!.movieId = data.movieId
                nextSegue!.movieName = data.name
                nextSegue!.selectDetails = data.detail
                nextSegue!.selectLarge_picture = data.large_picture
                nextSegue!.imdb = data.imdb

                if SearchData.count > 0 {
                    data = SearchData[indexPath.row]

                    nextSegue!.movieId = data.movieId
                    nextSegue!.movieName = data.name
                    nextSegue!.selectDetails = data.detail
                    nextSegue!.selectLarge_picture = data.large_picture
                    nextSegue!.imdb = data.imdb
                }
            }
        }
        if segue.identifier == "goto_movie_detail" {
            let nextSegue = segue.destination as? MovieDetailVC
            guard let tag = (sender as? UIButton)?.tag else { return }
                var data = TableData[tag]

                nextSegue!.movieId = data.movieId
                nextSegue!.movieName = data.name
                nextSegue!.selectDetails = data.detail
                nextSegue!.selectLarge_picture = data.large_picture
                nextSegue!.iMDB = data.imdb

                if SearchData.count > 0 {
                    data = SearchData[tag]

                    nextSegue!.movieId = data.movieId
                    nextSegue!.movieName = data.name
                    nextSegue!.selectDetails = data.detail
                    nextSegue!.selectLarge_picture = data.large_picture
                    nextSegue!.iMDB = data.imdb
                }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        veil = true
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
        if (veil) {
             dismiss(animated: true, completion: nil)
         }
         veil = false
         dismiss(animated: true, completion: nil)
    }

    func addData() {
        //TableData.removeAll()

        var errorOnLogin: GeneralRequestManager?
        var setFirstResult: Int?
 
        if(TableData.count > 0) {
            setFirstResult = TableData.count
        } else {
            setFirstResult = 0;
        }
        
        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/movies/paging", errors: "", method: "GET", headers: nil, queryParameters: ["setFirstResult": String(setFirstResult!)], bodyParameters: nil, isCacheable: "1", contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["movies"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        self.TableData.append(MoviesData(add: dataBlock))
                    }
                }
            }
            
            if let _ = json["NotFoundMovies"].string as NSString? {
                endOfFile = true
            }


            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
            })
        }
    }

    func addData_(_ match: String) {
        var errorOnLogin: GeneralRequestManager?

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/movies/search", errors: "", method: "GET", headers: nil, queryParameters: ["match": match], bodyParameters: nil, isCacheable: nil, contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["searchedMovies"].object as? NSArray {
                self.SearchData.removeAll()
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        self.SearchData.append(MoviesData(add: dataBlock))
                        shouldShowSearchResults = true
                    }
                }
            }

            if let _ = json["NotFoundMovies"].string as NSString? {
                // TODO: present empty list
            }

            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
            })
        }
    }

    func searchBarTextDidBeginEditing(_: UISearchBar) {
        shouldShowSearchResults = true
        // self.tableView!.reloadData()
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        shouldShowSearchResults = true
        searchController.searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_: UISearchBar) {
        shouldShowSearchResults = false
    }

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        if searchText.substring(from: searchText.startIndex).count > 2 {

            let backgroundQueue = DispatchQueue.global()
            let deadline = DispatchTime.now() + .milliseconds(100)
            backgroundQueue.asyncAfter(deadline: deadline, qos: .background) {
                self.addData_(searchText)
            }
        }

        if searchText.substring(from: searchText.startIndex).count == 0 {
            SearchData.removeAll()
            tableView!.reloadData()
        }
        shouldShowSearchResults = true
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
        }

        if TableData.count > 0 {
            data = TableData[indexPath.row]
        }

        if SearchData.count > 0 {
            data = SearchData[indexPath.row]
        }

        let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
        let detailText = NSMutableAttributedString(string: (data?.name)!, attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))

        cell!.textLabel?.attributedText = detailText
        cell!.textLabel?.numberOfLines = 2
       // TODO: pictures' size shall not exceed 100 kbytes
        if let url = URL(string: serverURL + "/simple-service-webapp/webapi/myresource" + (data?.large_picture)!) {
            if let imageData = try? Data(contentsOf: url) {
                cell!.imageView?.image = UIImage(data: imageData)
            }
        }
        
        //TODO: export method, and reload tableview
        /*
        var errorOnLogin: GeneralRequestManager?
        errorOnLogin = GeneralRequestManager(url: serverURL + "/simple-service-webapp/webapi/myresource" + (data?.large_picture)!, errors: "", method: "GET", headers: nil, queryParameters: nil, bodyParameters: nil, isCacheable: nil, contentType: "", bodyToPost: nil)

        errorOnLogin?.getData_ {
            (data: Data, _: NSError?) in
            let image = UIImage(data: data)
            cell!.imageView?.image = image
            }
        */
        
        let btn = UIButton(type: UIButton.ButtonType.custom) as UIButton
        btn.frame = CGRect(x: view.frame.width * 0.9, y: 0, width: 20, height: (cell?.frame.height)!)
        btn.addTarget(self, action: #selector(MoviesVC.movieDetail), for: .touchUpInside)
        btn.tag = indexPath.row
        btn.setImage(UIImage(named: "window-7.png"), for: .normal)
        cell?.contentView.addSubview(btn)

        return cell!
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if SearchData.count > 0 {
            return SearchData.count
        }

        return TableData.count
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
            performSegue(withIdentifier: "goto_venues", sender: self)
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == TableData.count - 3 {
            if(endOfFile == false) {
            //MoviesData.addData()
            addData()
            }
        }
    }

    @objc func movieDetail(button: UIButton, event: UIEvent) {
        if (veil && shouldShowSearchResults) {
            dismiss(animated: true, completion: nil)
        }
        veil = false
        shouldShowSearchResults = false
        performSegue(withIdentifier: "goto_movie_detail", sender: button)
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
