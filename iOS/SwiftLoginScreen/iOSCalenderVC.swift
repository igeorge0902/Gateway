//
//  iOSCalendarVC.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 25/09/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import Foundation
import EventKit
import UIKit

class iOSCalendarVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    deinit {
        attendeesArray.removeAll()
        attendeesDictionary.removeAll()
        attendeesIndexDictionary.removeAll()
        print(#function, "\(self)")
        print(#function, "\(self)")
    }
    
    var tableView:UITableView?
    var selectCalendar:NSIndexPath?
    lazy var eventStore = EKEventStore()
    var event:EKEvent?
    var calendars: [EKCalendar]?
    var calendars_:[EKCalendar]?
    
    lazy var datE = Date.formatDate(dateString: String(myDateString!.first!))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        calendars =  self.eventStore.calendars(for: EKEntityType.event) as [EKCalendar]
        calendars_ = self.calendars?.filter({ !$0.isSubscribed })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let frame:CGRect = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height / 1.5)
        self.tableView = UITableView(frame: frame)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        self.view.addSubview(self.tableView!)
        
        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: self.view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.setTitle("Attendees", for: UIControl.State.normal)
        btnNav.showsTouchWhenHighlighted = true
        btnNav.addTarget(self, action: #selector(iOSCalendarVC.navigateBack), for: UIControl.Event.touchUpInside)
        
        let btnAttendees = UIButton(frame: CGRect(x: self.view.frame.width / 2, y: 25, width: self.view.frame.width / 2, height: 20))
        btnAttendees.backgroundColor = UIColor.black
        btnAttendees.setTitle("Save", for: UIControl.State())
        btnAttendees.showsTouchWhenHighlighted = true
        btnAttendees.addTarget(self, action: #selector(iOSCalendarVC.calendar), for: UIControl.Event.touchUpInside)
        
        
        self.view.addSubview(btnAttendees)
        self.view.addSubview(btnNav)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    @objc func navigateBack() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func calendar(/*_ sender: UIButton*/) {
        
        self.event = EKEvent(eventStore: self.eventStore)
        
        self.event?.title = SelectMovieName!
        self.event?.startDate = self.datE
        self.event?.endDate = self.datE.addingTimeInterval(7200)
        self.event?.notes = "This is a note of creating event"
        self.event?.calendar = self.eventStore.defaultCalendarForNewEvents
        self.event?.addAlarm(EKAlarm.init(relativeOffset: 60.0))
        self.event?.location = SelectVenueForMovie
        self.event?.calendar = (self.calendars_?[(self.selectCalendar?.row)!])!
        
        
        do {
            
            try self.eventStore.save(self.event!, span: .thisEvent)
            
        } catch let specError as NSError {
            
            print("A specific error occurred: \(specError)")
            
        } catch {
            
            print("An error occurred")
        }
        self.showAlert(SelectMovieName!, message: "Event added to calendar: ".appending(String.formatDate(date: self.datE)))
        
    }
    
    // Helper for showing an alert
    func showAlert(_ title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if calendars_!.count > 0 {
            
            return calendars_!.count
            
        }
        return calendars!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
            
        }
        
        cell?.textLabel?.text = calendars_![indexPath.row].title
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectCalendar = indexPath as NSIndexPath?
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.isHighlighted = true
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
    }
    
    @objc func addAttendees() {
        
        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "Attendees")
        
        pvc.modalPresentationStyle = UIModalPresentationStyle.custom
        pvc.transitioningDelegate = self
        //pvc.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        self.present(pvc, animated: true, completion: nil)
        
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    
    
    class HalfSizePresentationController : UIPresentationController {
        
        override var frameOfPresentedViewInContainerView : CGRect {
            
                return CGRect(x: 0, y: 200, width: containerView!.bounds.width, height: containerView!.bounds.height)
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
