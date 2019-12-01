//
//  AttendeesVC.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 25/09/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import Foundation
import Contacts
import UIKit

var attendeesArray:Array<NSDictionary> = Array<NSDictionary>()
var attendeesIndexDictionary = [IndexPath:NSDictionary]()
var attendeesDictionary = [Int:NSDictionary]()
class AttendeesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var movieId:Int?
    
    deinit {
        print(#function, "\(self)")
    }
    
    var tableView:UITableView?
    var contacts = [CNContact]()
    var indexOfLetters = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.requestForAccess { (accessGranted) in }
        
        let index = "a b c d e f g h i j k l m n o p q r s t u v w x y z #"
        indexOfLetters = index.components(separatedBy: " ")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let frame:CGRect = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height / 2.2)
        self.tableView = UITableView(frame: frame)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        self.view.addSubview(self.tableView!)
        
        let btnData = UIButton(frame: CGRect(x: self.view.frame.width / 2, y: 25, width: self.view.frame.width / 2, height: 20))
        btnData.backgroundColor = UIColor.black
        btnData.showsTouchWhenHighlighted = true
        btnData.setTitle("Clear", for: UIControl.State.normal)
        btnData.addTarget(self, action: #selector(AttendeesVC.clearAttendees), for: UIControl.Event.touchUpInside)
        
        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: self.view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.showsTouchWhenHighlighted = true
        btnNav.setTitle("Back", for: UIControl.State.normal)
        btnNav.addTarget(self, action: #selector(AttendeesVC.navigateBack), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(btnData)
        self.view.addSubview(btnNav)
        
        self.contactS()
        
        //TODO: add UITextView to display select attendees
    }
    
    func clearAttendees() {
        
        attendeesDictionary.removeAll()
        attendeesIndexDictionary.removeAll()
        
        tableView?.reloadData()
    }
    
    
    func navigateBack() {
        
        self.dismiss(animated: true, completion: nil)
        
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
    
    func requestForAccess(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        // Get authorization
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        // Find out what access level we have currently
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            CNContactStore().requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    func contactS() {
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey,
            CNContactImageDataKey] as [Any]
        
        // let keys = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName)]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                self.contacts.append(contact)
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return contacts.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexOfLetters
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let temp = indexOfLetters as NSArray
        return temp.index(of: title)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
            
        }
        
        let data = contacts[indexPath.section]
        
        cell?.textLabel?.text = data.familyName + " " + data.givenName
        
        if attendeesIndexDictionary.count > 0 {
            
            if attendeesIndexDictionary.keys.contains(indexPath) {
                
                for (key, value) in attendeesIndexDictionary[indexPath]! {
                    
                    print("Value: \(value) for key: \(key)")
                    
                    if (key as! NSString) as String == "email" {
                        
                        cell?.detailTextLabel?.text = (value as! NSString) as String
                        
                    }
                    
                }
                
            }
            
            
        } else {
            
            cell?.detailTextLabel?.text = ""
            
        }
        
        
        
        
        if data.isKeyAvailable(CNContactImageDataKey) {
            
            if data.imageDataAvailable {
                
                cell?.imageView?.image = UIImage(data: data.imageData!)
                
            }
            
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentContact = contacts[indexPath.section]
        let cell = tableView.cellForRow(at: indexPath)
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Choose an option!", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        actionSheetController.addAction(cancelAction)
        
        var homeEmailAddress: String!
        for emailAddress in currentContact.emailAddresses {
            
            homeEmailAddress = emailAddress.value as String
            
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: homeEmailAddress, style: .default) { action -> Void in
                
                let attendees = ["email": homeEmailAddress, "displayName": currentContact.givenName, "responseStatus": "needsAction"] as [String : Any]
                
                attendeesIndexDictionary.updateValue(attendees as NSDictionary, forKey: indexPath)
                attendeesDictionary.updateValue(attendees as NSDictionary, forKey: indexPath.row)
                
                for attendee in attendeesDictionary.values {
                    
                    attendeesArray.append(attendee as NSDictionary)
                    
                }
                
                cell?.detailTextLabel?.text = homeEmailAddress
                
                
            }
            
            actionSheetController.addAction(takePictureAction)
        }
        
        let removeAction: UIAlertAction = UIAlertAction(title: "Remove", style: .default) { action -> Void in
            
            attendeesIndexDictionary.removeValue(forKey: indexPath)
            attendeesDictionary.removeValue(forKey: indexPath.row)
            cell?.detailTextLabel?.text = ""
            
        }
        
        actionSheetController.addAction(removeAction)

        //Present the AlertController
        actionSheetController.popoverPresentationController?.sourceView = self.view
        present(actionSheetController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.isHighlighted = true
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
    }
    
    
}

