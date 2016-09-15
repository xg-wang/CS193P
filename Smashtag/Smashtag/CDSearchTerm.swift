//
//  CDSearchTerm.swift
//  Smashtag
//
//  Created by Xingan Wang on 9/11/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import Foundation
import CoreData


class CDSearchTerm: NSManagedObject {

    class func searchTermWithTerm(term: String, inManagedObjectContext context: NSManagedObjectContext) -> CDSearchTerm? {
        let request = NSFetchRequest(entityName: "CDSearchTerm")
        // TODO!
        
        return nil
    }

}
