//
//  PopOver2.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 26/07/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import Foundation
import UIKit

extension TableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        
        // Stops collection view if it was scrolling.
        collectionView.setContentOffset(collectionView.contentOffset, animated:true)
        collectionView.reloadData()
    }
    
    
    var collectionViewOffset: CGFloat {
        set {
            collectionView.contentOffset.x = newValue
        }
        get {
            return collectionView.contentOffset.x
        }
    }
}
