//
//  CDSearchTerm+CoreDataProperties.swift
//  Smashtag
//
//  Created by Xingan Wang on 9/11/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDSearchTerm {

    @NSManaged var term: String
    @NSManaged var mentions: NSSet?
    @NSManaged var tweets: NSSet?

}
