//
//  FeedCells.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 13/09/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import Foundation
import UIKit

class FeedCells: UICollectionViewCell {
    
    var textLabel: UILabel?
    var profileImage: UIImageView?
    var statusText: UITextView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        profileImage?.contentMode = .scaleAspectFit
        profileImage?.backgroundColor = UIColor.clear
        profileImage?.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel = UILabel(frame: CGRect(x: frame.width * 0.2 , y: 0, width: frame.size.width, height: 40))
        textLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        textLabel?.textAlignment = .center
        
        statusText = UITextView(frame: CGRect(x: 1 , y: 60, width: frame.size.width * 0.8, height: 100))
        statusText?.font = UIFont.systemFont(ofSize: 14)
        statusText?.textAlignment = .left
        
        contentView.addSubview(statusText!)
        contentView.addSubview(profileImage!)
        contentView.addSubview(textLabel!)
        
        addConstraintswithFormat("H:|-8-[v0(44)]-8-[v1]|", views: profileImage!, textLabel!)
        addConstraintswithFormat("V:|-12-[v0]", views: textLabel!)
        addConstraintswithFormat("V:|-8-[v0(44)]", views: profileImage!)
        addConstraintswithFormat("H:|-4-[v0]-4-|", views: statusText!)
        addConstraintswithFormat("V:|-8-[v0(44)]-4-[v1(90)]", views: profileImage!, statusText!)
    
        /*
        let viewsDictionaryOne = ["label1": profileImage, "label2": textLabel]
        let viewsDictionaryTwo = ["label2": textLabel]
        let viewsDictionaryThree = ["label1": profileImage]
        let viewsDictionaryFour = ["label3": statusText]
        let viewsDictionaryFive = ["label1": profileImage, "label3": statusText]

        contentView.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0(44)]-8-[v1]|", options: [], metrics: nil, views: viewsDictionaryOne as [String : Any]))
        contentView.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[v0]", options: [], metrics: nil, views: viewsDictionaryTwo as [String : Any]))
        contentView.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(44)]", options: [], metrics: nil, views: viewsDictionaryThree as [String : Any]))
        contentView.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[v0]-4-|", options: [], metrics: nil, views: viewsDictionaryFour as [String : Any]))
        contentView.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(44)]-4-[v1(90)]", options: [], metrics: nil, views: viewsDictionaryFive as [String : Any]))
         */
    }
    
    func toggleSelected ()
    {
        if (isSelected){
            
            backgroundColor = UIColor.purple
            
        }else {
            
            backgroundColor = UIColor.white
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
