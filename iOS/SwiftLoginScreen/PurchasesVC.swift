//
//  Purchases.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 2017. 09. 15..
//  Copyright © 2017. George Gaspar. All rights reserved.
//

import Foundation
import SwiftyJSON

var TableData:Array< PurchaseData > = Array < PurchaseData >()
class PurchasesVC: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    deinit {
        TableData.removeAll()
        print(#function, "\(self)")
    }
    
    var refreshControl: UIRefreshControl!
    var tableView:UITableView?
    
    var ResponseText:String?
    var ResponseCode:String?
    var AuthCode:String?
    var Status:String?
    var Amount:String?
    var TaxAmount:String?
    var movieName:String?
    var purchaseId:String?
    
    lazy var layout = UICollectionViewFlowLayout()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let frame:CGRect = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height-100)
        self.tableView = UITableView(frame: frame)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        self.view.addSubview(self.tableView!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        refreshControl = UIRefreshControl()
        self.tableView?.addSubview(self.refreshControl)
        
        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: self.view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.showsTouchWhenHighlighted = true
        btnNav.setTitle("Back", for: UIControl.State.normal)
        btnNav.addTarget(self, action: #selector(BasketVC.navigateBack), for: UIControl.Event.touchUpInside)
        
        let btnData = UIButton(frame: CGRect(x: self.view.frame.width / 2, y: 25, width: self.view.frame.width / 2, height: 20))
        btnData.backgroundColor = UIColor.black
        btnData.setTitle("CheckOut", for: UIControl.State())
        btnData.showsTouchWhenHighlighted = true
        btnData.addTarget(self, action: #selector(BasketVC.book), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(btnNav)
        
        //self.view.addSubview(btnData)
        self.addPurchasesData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func navigateBack() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goto_tickets" {
            let nextSegue = segue.destination as? TicketsVC
            nextSegue?.purchaseId = purchaseId
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
            
        }
        
        let data = TableData[indexPath.section]
        
        let myTextAttribute = [ convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)! ]
        let detailText = NSMutableAttributedString(string: data.movie_name, attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute) )
        
        detailText.append(NSAttributedString(string: "\n\(TableData[indexPath.section].screeningDate!)", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 12.0)!, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)])))
        
        cell!.textLabel?.numberOfLines = 5
        //cell!.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        cell!.textLabel?.attributedText = detailText
        
        if let urlMovie = URL(string: serverURL + "/simple-service-webapp/webapi/myresource" + TableData[indexPath.section].movie_picture) {
            
            if let movieImage = try? Data(contentsOf: urlMovie) {
                
                cell!.imageView?.image = UIImage(data: movieImage)
            }
        }
        
        return cell!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return TableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue != 0 {
            
            purchaseId = TableData[indexPath.section].purchaseId
            self.performSegue(withIdentifier: "goto_tickets", sender: self)
            
        }
    }
    
    func addPurchasesData() {
        
        var errorOnLogin:GeneralRequestManager?
        
        errorOnLogin = GeneralRequestManager(url: serverURL + "/login/GetAllPurchases", errors: "", method: "GET", queryParameters: nil, bodyParameters: nil, isCacheable: nil, contentType: contentType_.urlEncoded.rawValue, bodyToPost: nil)
        
        errorOnLogin?.getResponse {
            
            (json: JSON, error: NSError?) in
            
            if let list = json["purchases"].object as? NSArray {
                
                for i in 0 ..< list.count {
                    
                    if let dataBlock = list[i] as? NSDictionary {
                        
                        TableData.append(PurchaseData(add: dataBlock))
                        
                    }
                    
                }
                
            }
            
            DispatchQueue.main.async(execute: {
                
                self.tableView?.reloadData()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
