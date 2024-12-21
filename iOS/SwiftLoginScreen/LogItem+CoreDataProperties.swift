//
//  LogItem+CoreDataProperties.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 11/11/15.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import CoreData
import Foundation

extension LogItem {
    @NSManaged var title: String?
    @NSManaged var itemText: String?
}
