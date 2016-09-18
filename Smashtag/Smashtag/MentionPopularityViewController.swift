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
        guard let context = managedObjectContext where searchText?.characters.count > 0 else {
                fetchedResultsController = nil
                return
        }
        let request = NSFetchRequest(entityName: "CDMention")
        request.predicate = NSPredicate(format: "term.term contains[c] %@ and count > %@", searchText!, "1")
        request.sortDescriptors = [
            NSSortDescriptor(key: "count", ascending: false),
            NSSortDescriptor(key: "keyword", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MentionCell", forIndexPath: indexPath)
        
        if let mention = fetchedResultsController?.objectAtIndexPath(indexPath) as? CDMention {
            var keyword: String?
            var count: Int16 = 0
            mention.managedObjectContext?.performBlockAndWait {
                keyword = mention.keyword
                count = mention.count.shortValue
            }
            cell.textLabel?.text = keyword
            cell.detailTextLabel?.text = "\(count) tweets mentioned"
        }
        
        return cell
    }
    
}
