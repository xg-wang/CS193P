//
//  CDTweet+CoreDataProperties.swift
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

extension CDMention {

    @NSManaged var count: NSNumber
    @NSManaged var keyword: String
    @NSManaged var term: CDSearchTerm?

}
