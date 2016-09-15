//
//  MentionPopularityViewController.swift
//  Smashtag
//
//  Created by Xingan Wang on 9/8/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit
import CoreData

class MentionPopularityViewController: CoreDataTableViewController {
    
    var searchText: String? { didSet { _updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet { _updateUI() } }
    
    private func _updateUI() {
        guard let
            search = searchText,
            context = managedObjectContext else {
                fetchedResultsController = nil
        }
        // TODO!
        let request = NSFetchRequest(entityName: "CDMention")
        request.predicate = NSPredicate(format: "tweets.searchTerm contains[c] %@ and count > %@", searchText, "1")
        request.sortDescriptors = [
            NSSortDescriptor(key: "count", ascending: false),
            NSSortDescriptor(key: "keyword", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        ]
    }
    
}
