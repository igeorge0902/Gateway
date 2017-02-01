//
//  ViewController.swift
//  devdactic-rest
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import UIKit
import SwiftyJSON

class MenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    deinit {
        print(#function, "\(self)")
    }
    
    var refreshControl: UIRefreshControl!
    var tableView:UITableView?
    var items = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        refreshControl = UIRefreshControl()
        self.tableView?.addSubview(self.refreshControl)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let frame:CGRect = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height-100)
        self.tableView = UITableView(frame: frame)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        self.view.addSubview(self.tableView!)
        
        let btnData = UIButton(frame: CGRect(x: self.view.frame.width / 2, y: 25, width: self.view.frame.width / 2, height: 20))
        btnData.backgroundColor = UIColor.black
        btnData.setTitle("Profile", for: UIControlState())
        btnData.addTarget(self, action: #selector(MenuVC.addData), for: UIControlEvents.touchUpInside)
        
        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: self.view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.setTitle("Back", for: UIControlState())
        btnNav.addTarget(self, action: #selector(MenuVC.navigateBack), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(btnData)
        self.view.addSubview(btnNav)
    }
    
    
    func navigateBack() {

        self.dismiss(animated: true, completion: nil)
        
    }
    
    func addData() {
        
        RestApiManager.sharedInstance.getRandomUser {
            (json: JSON, error: NSError?) in
            
            // Get the appropiate part of the JSON object (then iterate over it), or just get the whole if it is of one level
                let users: AnyObject = json["user"].object as AnyObject
                self.items.add(users)
                DispatchQueue.main.async(execute: { self.tableView?.reloadData()})
        }
        
        //TODO: save some data to coredata
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        
       // if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL")
       // }
        
        let user:JSON =  JSON(self.items[indexPath.row])
        
       // let picURL = user["picture"]["medium"].string
       // let url = NSURL(string: picURL!)
       // let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        
        cell!.textLabel?.text = user.string
       // cell!.imageView?.image = UIImage(data: data!)
        
        return cell!
    }
    
}

