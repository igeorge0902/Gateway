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


// data modell for updating Screen
var ScreenData_2: [Admin_ScreenData] = [Admin_ScreenData]()

var TableData_: [MoviesData] = [MoviesData]()
var endOfFile = false
var veil = true
var shouldShowSearchResults = false
class MoviesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    deinit {
        endOfFile = false
        TableData.removeAll()
        adminPage = false
        adminUpdatePage = false
        print(#function, "\(self)")
    }
    
    var SearchData: [MoviesData] = [MoviesData]()
    var TableData: [MoviesData] = [MoviesData]()
//    var ScreenData_: [datastruct] = [datastruct]()
    var CategoryData = [String]()
    var data: MoviesData?
    var venueData: Admin_ScreenData?
    var searchController: UISearchController?
    lazy var session = URLSession.sharedCustomSession

    var refreshControl: UIRefreshControl!
    var tableView: UITableView?
    var section_: Int = 0
    var category_: String?
    var searchString: String?
 
 /*
    struct datastruct : Equatable {
        var movie: String!
        var movieId: String!
        var date: String!
        var venue: String!
        var venueId: String!
        var ScreeningId: String!
        var screeningDatesId: String?

        init(add: NSDictionary) {
            movie = (add["movie"] as! String)
            movieId = (add["movieId"] as! String)
            date = (add["date"] as! String)
            venue = (add["venue"] as! String)
            venueId = (add["venue"] as! String)
            ScreeningId = (add["ScreeningId"] as! String)
            screeningDatesId = (add["screeningDatesId"] as! String)
        }

    }
*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goto_venues" {
            let nextSegue = segue.destination as? VenuesVC

            if let indexPath = self.tableView!.indexPathForSelectedRow {
                var data: MoviesData

                if TableData.count > 0 {
                    data = TableData[indexPath.section]

                    nextSegue!.movieId = data.movieId
                    nextSegue!.movieName = data.name
                    nextSegue!.selectDetails = data.detail
                    nextSegue!.selectLarge_picture = data.large_picture
                    nextSegue!.imdb = data.imdb
                }
                if SearchData.count > 0 {
                    data = SearchData[indexPath.section]

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
            var data: MoviesData

            if TableData.count > 0 {
                data = TableData[tag]

                nextSegue!.movieId = data.movieId
                nextSegue!.movieName = data.name
                nextSegue!.selectDetails = data.detail
                nextSegue!.selectLarge_picture = data.large_picture
                nextSegue!.iMDB = data.imdb
            }
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

      //  refreshControl = UIRefreshControl()
      //  tableView?.addSubview(refreshControl)


        // Initialize and set up the search controller
        searchController = UISearchController(searchResultsController: nil)

        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search in Title and Description..."
        searchController?.searchBar.autocapitalizationType = .none
        searchController?.searchBar.searchBarStyle = .minimal
        definesPresentationContext = true

        searchController?.searchBar.sizeToFit()

        let searchBarFrame = UIView(frame: CGRect(x: 0.0, y: 50, width: view.frame.width, height: 44))
        searchBarFrame.addSubview(searchController!.searchBar)
        view.addSubview(searchBarFrame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigateBack), name: NSNotification.Name(rawValue: "navigateBack"), object: nil)
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
        
        if (adminUpdatePage == true) {
            TableData.removeAll()
            addLoadMoviesonVenue()
        } else {
            addData(category: "nil")
        }
    }
    

    @objc func navigateBack() {
        if veil {
            dismiss(animated: true, completion: nil)
        }
        veil = false
        dismiss(animated: true, completion: nil)
    }

    /// Returns a categorized list of movies with paging by 30 results.
    ///
    /// - Parameters:
    ///   - category: Name of the category.
    /// - Returns: list of ``MoviesData`` objects.
    func addData(category: String) {

        var errorOnLogin: GeneralRequestManager?
        var setFirstResult: Int?
        var query: [String: String]?

        if category != "nil" {
            query = ["category": category, "setFirstResult": String(TableData.count)]
        } else if TableData.count > 0, category == "nil" {
            setFirstResult = TableData.count
            query = ["setFirstResult": String(setFirstResult!)]
        } else {
            setFirstResult = 0
            query = ["setFirstResult": String(setFirstResult!)]
        }

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/movies/paging", errors: "", method: "GET", headers: nil, queryParameters: query, bodyParameters: nil, isCacheable: "1", contentType: "", bodyToPost: nil)

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
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    func addLoadMoviesonVenue(category: String) {
        // TableData.removeAll()

        var errorOnLogin: GeneralRequestManager?
        var query: [String: String]?

        if category != "nil" {
            query = ["category": category]
        }

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/admin/moviesonvenuescategorized", errors: "", method: "GET", headers: nil, queryParameters: query, bodyParameters: nil, isCacheable: "1", contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["venues"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        ScreenData_2.append(Admin_ScreenData(add: dataBlock))

                    }
                }
            }

            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    func addLoadMoviesonVenue(search: String) {
        // TableData.removeAll()

        var errorOnLogin: GeneralRequestManager?
        var query: [String: String]?
        query = ["match": search]

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/admin/moviesonvenuessearch", errors: "", method: "GET", headers: nil, queryParameters: query, bodyParameters: nil, isCacheable: "1", contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["venues"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        ScreenData_2.append(Admin_ScreenData(add: dataBlock))

                    }
                }
            }

            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }

    func addData_(_ match: String, category: String) {
        SearchData.removeAll()
        var errorOnLogin: GeneralRequestManager?
        var setFirstResult: Int?
        var query: [String: String]?

        if SearchData.count > 0, category != "nil" {
            setFirstResult = SearchData.count
            query = ["match": match, "setFirstResult": String(setFirstResult!), "category": category]
        } else if SearchData.count > 0, category == "nil" {
            setFirstResult = SearchData.count
            query = ["match": match, "setFirstResult": String(setFirstResult!)]
        } else if SearchData.count == 0, category != "nil" {
            setFirstResult = SearchData.count
            query = ["match": match, "setFirstResult": String(setFirstResult!), "category": category]
        } else if SearchData.count == 0, category == "nil" {
            setFirstResult = SearchData.count
            query = ["match": match, "setFirstResult": String(setFirstResult!)]
        }

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/movies/search", errors: "", method: "GET", headers: nil, queryParameters: query, bodyParameters: nil, isCacheable: nil, contentType: "", bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, _: NSError?) in

            if let list = json["searchedMovies"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        self.SearchData.append(MoviesData(add: dataBlock))
                        shouldShowSearchResults = true
                    }
                }
            }

            if let _ = json["NotFoundMovies"].string as NSString? {
                // TODO: present empty list
                endOfFile = true
            }

            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc func addLoadMoviesonVenue() {

        ScreenData_2.removeAll()
        var errorOnLogin: GeneralRequestManager?

        errorOnLogin = GeneralRequestManager(url: serverURL + "/mbooks-1/rest/book/admin/moviesonvenues", errors: "", method: "GET", headers: nil, queryParameters: nil, bodyParameters: nil, isCacheable: nil, contentType: contentType_.json.rawValue, bodyToPost: nil)

        errorOnLogin?.getResponse {
            (json: JSON, error: NSError?) in

            if let list = json["venues"].object as? NSArray {
                for i in 0 ..< list.count {
                    if let dataBlock = list[i] as? NSDictionary {
                        ScreenData_2.append(Admin_ScreenData(add: dataBlock))

                    }
                }
            
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "venueSelected"), object: nil)
            }
            
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        
    }

    func searchBarTextDidBeginEditing(_: UISearchBar) {
        shouldShowSearchResults = true
        // self.tableView!.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

       // self.searchController!.searchBar.isHidden = true;
        searchController?.searchBar.resignFirstResponder()
         return true
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        shouldShowSearchResults = true
        searchController?.searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_: UISearchBar) {
        shouldShowSearchResults = true
        searchController?.searchBar.resignFirstResponder()
    }

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        if searchText.substring(from: searchText.startIndex).count > 2 {
            TableData.removeAll()
            SearchData.removeAll()
            if (!adminUpdatePage) {
            let backgroundQueue = DispatchQueue.global()
            let deadline = DispatchTime.now() + .milliseconds(100)
            backgroundQueue.asyncAfter(deadline: deadline, qos: .background) {
                if self.section_ == 0 {
                    self.addData_(searchText, category: "nil")
                } else if self.section_ == 1 {
                    self.addData_(searchText, category: self.category_!)
                    }
                }
            }
            
            if (adminUpdatePage) {
                ScreenData_2.removeAll()
                if self.section_ == 0 {
                    addLoadMoviesonVenue(search: searchText)
                } else if self.section_ == 1 {
                    addLoadMoviesonVenue(search: searchText)
                }
            }
        }

        if searchText.substring(from: searchText.startIndex).count == 0 {
            SearchData.removeAll()
            TableData.removeAll()
            if (!adminUpdatePage) {
            addData(category: category_ ?? "nil")
            tableView!.reloadData()
            }
            if (adminUpdatePage) {
            addLoadMoviesonVenue()
            tableView?.reloadData()
            }
        }
        shouldShowSearchResults = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        searchString = searchController.searchBar.text
        print(searchString!)
    }

    func searchDisplayController(_: UISearchController, shouldReloadTableForSearchString _: NSString) {}

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let control = UISegmentedControl(items: ["Reset", "Categories", "NA"])
        control.backgroundColor = UIColor.darkGray
        control.addTarget(self, action: #selector(MoviesVC.valueChanged(_:)), for: UIControl.Event.valueChanged)
        if section == 0 {
            return control
        }

        return nil
    }

    @objc func valueChanged(_ segmentedControl: UISegmentedControl) {
        print("Coming in : \(segmentedControl.selectedSegmentIndex)")
        section_ = segmentedControl.selectedSegmentIndex
        if segmentedControl.selectedSegmentIndex == 0 {
            searchController?.searchBar.text = ""
            category_ = nil
            SearchData.removeAll()
            TableData.removeAll()
            CategoryData.removeAll()
            ScreenData_2.removeAll()
            if (adminUpdatePage) {
            addLoadMoviesonVenue()
            } else {
            addData(category: "nil")
            }
        } else if section_ == 1 {
            searchController?.searchBar.text = ""
            CategoryData = ["Action", "Drama", "Crime", "Romance", "Troll"]
            SearchData.removeAll()
            TableData.removeAll()
            ScreenData_2.removeAll()
            tableView!.reloadData()
        } else if segmentedControl.selectedSegmentIndex == 2 {}
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        if(adminUpdatePage) {
            return 30
        }
        if(CategoryData.count > 0) {
            return 30
        }
        return 120.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as! ListViewCell?

        if(adminUpdatePage) {
            
            if cell == nil {
                cell = ListViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
            }
            if ScreenData_2.count > 0 {
                venueData = ScreenData_2[indexPath.row]
            }
            
            if TableData.count > 0 {
                data = TableData[indexPath.row]
            }
            if SearchData.count > 0 {
                data = SearchData[indexPath.row]
            }
            
            if ScreenData_2.count > 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "CELL2") as? ListViewCell

                if cell == nil {
                    cell = ListViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL2")
                }
                // TODO: add date to details so that the user can see more info when selecting
                let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
                let detailText = NSMutableAttributedString(string: ScreenData_2[indexPath.row].movie, attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))

                cell!.textLabel?.attributedText = detailText
            }
            else if CategoryData.count > 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "CELL2") as? ListViewCell

                if cell == nil {
                    cell = ListViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL2")
                }

                let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
                let detailText = NSMutableAttributedString(string: CategoryData[indexPath.row], attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))

                cell!.textLabel?.attributedText = detailText

            } else {
                let btn = UIButton(type: UIButton.ButtonType.custom) as UIButton
                btn.frame = CGRect(x: view.frame.width * 0.9, y: 15, width: 20, height: 30)
                btn.addTarget(self, action: #selector(MoviesVC.movieDetail), for: .touchUpInside)
                btn.tag = indexPath.row
                btn.setImage(UIImage(named: "window-7.png"), for: .normal)

                let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
                let detailText = NSMutableAttributedString(string: (data?.name)!, attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))

                cell!.textLabel?.attributedText = detailText
                cell!.textLabel?.numberOfLines = 3
                // TODO: pictures' size shall not exceed 100 kbytes
                
                let urlString = serverURL + "/simple-service-webapp/webapi" + (data?.large_picture)!
                
                if let url = URL(string: urlString) {

                    var loadPictures: GeneralRequestManager?
                    loadPictures = GeneralRequestManager(url: urlString, errors: "", method: "GET", headers: nil, queryParameters: nil, bodyParameters: nil, isCacheable: "1", contentType: "", bodyToPost: nil)
                    
                    
                    loadPictures?.getData_ {
                    (data: Data, _: NSError?) in
                    let image = UIImage(data: data)
                    cell!.imageView?.image = image
                    }
                    /*
                    if let imageData = try? Data(contentsOf: url) {
                        cell!.imageView?.image = UIImage(data: imageData)
                        }
                    */
                }
                
                if (!adminPage) {
                cell?.contentView.addSubview(btn)
                }
                cell?.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))

            }
        } else {
            
            if cell == nil {
                cell = ListViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
            }
            if ScreenData_2.count > 0 {
                venueData = ScreenData_2[indexPath.section]
            }
            
            if TableData.count > 0 {
                data = TableData[indexPath.section]
            }
            if SearchData.count > 0 {
                data = SearchData[indexPath.section]
            }
            
            if ScreenData_2.count > 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "CELL2") as? ListViewCell
                
                if cell == nil {
                    cell = ListViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL2")
                }
                // TODO: add date to details so that the user can see more info when selecting
                let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
                let detailText = NSMutableAttributedString(string: ScreenData_2[indexPath.section].movie, attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))
                
                cell!.textLabel?.attributedText = detailText
            }
            else if CategoryData.count > 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "CELL2") as? ListViewCell
                
                if cell == nil {
                    cell = ListViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL2")
                }
                
                let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
                let detailText = NSMutableAttributedString(string: CategoryData[indexPath.row], attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))
                
                cell!.textLabel?.attributedText = detailText
                
            } else {
                let btn = UIButton(type: UIButton.ButtonType.custom) as UIButton
                btn.frame = CGRect(x: view.frame.width * 0.9, y: 15, width: 20, height: 30)
                btn.addTarget(self, action: #selector(MoviesVC.movieDetail), for: .touchUpInside)
                btn.tag = indexPath.section
                btn.setImage(UIImage(named: "window-7.png"), for: .normal)
                
                let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
                let detailText = NSMutableAttributedString(string: (data?.name)!, attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))
                
                cell!.textLabel?.attributedText = detailText
                cell!.textLabel?.numberOfLines = 3
                
                let urlString = serverURL + "/simple-service-webapp/webapi" + (data?.large_picture)!
                                    
                    var loadPictures: GeneralRequestManager?
                    loadPictures = GeneralRequestManager(url: urlString, errors: "", method: "GET", headers: nil, queryParameters: nil, bodyParameters: nil, isCacheable: "1", contentType: "", bodyToPost: nil)
                    
                    loadPictures?.getData_ {
                    (data: Data, _: NSError?) in
                    let image = UIImage(data: data)
                    cell!.imageView?.image = image
                    cell!.imageView?.image = image
            
                }
                
                if (!adminPage) {
                    cell?.contentView.addSubview(btn)
                }
                cell?.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
            }
        }
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int  {
        if(adminUpdatePage) {
            return 1;
            
        } else {
            
            if SearchData.count > 0 {
                return SearchData.count
            }
            if CategoryData.count > 0 {
                return 1;
            }
            if ScreenData_2.count > 0 {
                return ScreenData_2.count
            }
            return TableData.count
            
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(adminUpdatePage) {
            if SearchData.count > 0 {
                return SearchData.count
            }
            if CategoryData.count > 0 {
                return CategoryData.count
            }
            if ScreenData_2.count > 0 {
                return ScreenData_2.count
            }
            return TableData.count
            
        } else if (section_ == 1){
            
            if CategoryData.count > 0 {
                return CategoryData.count
            }
            
        } else {
            
            return 1
            
        }
        return 1
    }
            
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController!.searchBar.isHidden = false;

        if (adminPage && CategoryData.count == 0) {
            if(TableData.count > 0) {
                addMovie = TableData[indexPath.section].name
            } else {
        addMovie = SearchData[indexPath.section].name
            }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newScreenMovieSelected"), object: nil)
        }
        
        if (adminUpdatePage && CategoryData.count == 0) {
            if(ScreenData_2.count > 0) {
                addMovie = ScreenData_2[indexPath.row].movie
                addVenue = ScreenData_2[indexPath.row].venue
                addScreeningID = ScreenData_2[indexPath.row].ScreeningId
                addScreeningDate = ScreenData_2[indexPath.row].date
                addScreeningDateId = ScreenData_2[indexPath.row].screeningDatesId
                addMovieId = ScreenData_2[indexPath.row].movieId
                addVenueId = ScreenData_2[indexPath.row].venueId
                addCategory = ScreenData_2[indexPath.row].category
            }

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "movieSelected"), object: nil)
        }

        if CategoryData.count > 0 {
            // select category
            category_ = CategoryData[indexPath.row]
            CategoryData.removeAll()
            TableData.removeAll()
            if (!adminUpdatePage) {
            addData(category: category_!)
            }
            if adminUpdatePage {
                // add admin movie:venue with category
                addLoadMoviesonVenue(category: category_!)
            }
        } else {
            if (adminPage || adminUpdatePage) {} else {
                if veil, shouldShowSearchResults {
                    dismiss(animated: true, completion: nil)
                }
                veil = false
                shouldShowSearchResults = false
                performSegue(withIdentifier: "goto_venues", sender: self)
                
            }
        }
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.searchController!.searchBar.isHidden = false;

        if TableData.count > 10 || SearchData.count > 10 {
            if indexPath.section == TableData.count - 3 {
                if endOfFile == false {
                       self.addData(category: "nil")
                }
                if indexPath.section == SearchData.count - 3, section_ == 0, endOfFile == false {
                    addData_(searchString!, category: "nil")
                } else if indexPath.section == SearchData.count - 3, section_ == 1, endOfFile == false {
                    addData_(searchString!, category: category_!)
                }
            }
        }
        if(adminUpdatePage) {
            if TableData.count > 10 || SearchData.count > 10 {
                if indexPath.row == TableData.count - 3 {
                    if endOfFile == false {
                        self.addData(category: "nil")
                    }
                    if indexPath.row == SearchData.count - 3, section_ == 0, endOfFile == false {
                        addData_(searchString!, category: "nil")
                    } else if indexPath.row == SearchData.count - 3, section_ == 1, endOfFile == false {
                        addData_(searchString!, category: category_!)
                    }
                }
            }
        }
      //  tableView?.reloadRows(at: [indexPath], with: .none)
    }

    @objc func movieDetail(button: UIButton, event _: UIEvent) {
        if veil, shouldShowSearchResults {
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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
