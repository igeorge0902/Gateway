//
//  CachedURLResponse+CoreDataProperties.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 15/11/15.
//  Copyright © 2015 Dipin Krishna. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CachedURLResponse {

    @NSManaged var data: NSData?
    @NSManaged var encoding: String?
    @NSManaged var mimeType: String?
    @NSManaged var statusCode: NSNumber?
    @NSManaged var timestamp: NSDate?
    @NSManaged var url: String?

}
