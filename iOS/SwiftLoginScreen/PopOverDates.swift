//
//  PopOverDates.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 09/09/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//
//

import UIKit
import SwiftyJSON
import CoreData

var SelectScreeningDateText:String?
var myDateString:[String.CharacterView.SubSequence]?
var screeningDateId:String?
var SelectMovieName:String?
var SelectMoviePicture:String?
var SelectVenueForMovie:String?
var SelectVenueName:String?
var numberOfRows:Array <String> = Array<String>()
class PopOverDates: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    deinit {
        print(#function, "\(self)")
        
        /*
        var filteredAttendees = SeatsData_.filter({
            $0.seatRow == String(0)
        })
        */
        
        for i in 0 ..< SeatsData_.count {
            
            if !numberOfRows.contains(SeatsData_[i].seatRow) {
                numberOfRows.append(SeatsData_[i].seatRow)
            }
        }
    }
    
    lazy var pickerView: UIPickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.frame = CGRect(x: 0, y: -(self.view.frame.height / 34), width: self.view.frame.width, height: self.view.frame.height / 4);
       // pickerView.sizeToFit()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true;
        
        self.view.addSubview(pickerView)
        self.pickerView.isHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return ScreeningDates.count
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = ScreeningDates[row].screeningDate
        var myTitle:NSAttributedString!
        let myTextAttribute = [ NSFontAttributeName: UIFont(name: "CourierNewPS-BoldMT", size: 14.0)! ]

        if row > 0 {
            
            let myDateString_ = titleData!.characters.split(separator: ".")
            let date_ = Date.formatDate(dateString: String(myDateString_.first!))
            
            myTitle = NSMutableAttributedString(string: String.formatDate(date: date_), attributes: myTextAttribute )
            
        } else {
            
            myTitle = NSMutableAttributedString(string: titleData!, attributes: myTextAttribute )
            
        }

        return myTitle
    }*/
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            //let hue = CGFloat(row)/CGFloat(ScreeningDates.count)
            //pickerLabel?.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        let titleData = ScreeningDates[row].screeningDate
        var myTitle:NSAttributedString!

        if row > 0 {

        let myDateString_ = titleData!.characters.split(separator: ".")
        let date_ = Date.formatDate(dateString: String(myDateString_.first!))
        
            myTitle = NSAttributedString(string: String.formatDate(date: date_), attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont(name: "CourierNewPS-BoldMT", size: 16.0)!,convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor):UIColor.black]))
            
            pickerLabel!.attributedText = myTitle
            pickerLabel!.textAlignment = .center
        
        } else {

            myTitle = NSAttributedString(string: titleData!, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont(name: "CourierNewPS-BoldMT", size: 14.0)!,convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor):UIColor.black]))

            pickerLabel!.attributedText = myTitle
            pickerLabel!.textAlignment = .left
        }
        
        return pickerLabel!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        SelectScreeningDateText = ScreeningDates[row].screeningDate
        
        if ScreeningDates[row].screeningDatesId != 0 {
    //    SeatsData.addData(ScreeningDates[row].screeningDatesId)
        screeningDateId = String(ScreeningDates[row].screeningDatesId)
        myDateString = SelectScreeningDateText!.characters.split(separator: ".")
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.view.frame.height / 3
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
