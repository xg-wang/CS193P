//
//  CDTweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Xingan Wang on 9/9/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDTweet {

    @NSManaged var uniqueId: String
    @NSManaged var mentions: NSSet?

}
