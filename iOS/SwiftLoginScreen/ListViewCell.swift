//
//  ListViewCell.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 2021. 01. 26..
//  Copyright © 2021. George Gaspar. All rights reserved.
//

import Foundation
import UIKit

class ListViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.white
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     //   let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
     //   bounds = bounds.inset(by: padding)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
