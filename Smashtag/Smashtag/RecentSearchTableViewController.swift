//
//  RecentSearchTableViewController.swift
//  Smashtag
//
//  Created by Xingan Wang on 8/31/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: UITableViewController {

    // MARK: - Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    private struct StoryBoard {
        static let cellIdentifier = "RecentSearchTerm"
        static let showSegueIdentifier = "ShowHistorySearchSegue"
        static let disclosureIdentifier = "DiscloseDetailSegue"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearch().values.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = RecentSearch().values[indexPath.row]
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            RecentSearch().removeAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier where identifier == StoryBoard.showSegueIdentifier {
            if let ttvc = segue.destinationViewController as? TweetTableViewController {
                if let cell = sender as? UITableViewCell {
                    ttvc.searchText = cell.textLabel?.text
                }
            }
        } else if let identifier = segue.identifier where identifier == StoryBoard.disclosureIdentifier {
            if let mpvc = segue.destinationViewController as? MentionPopularityViewController {
                if let cell = sender as? UITableViewCell {
                    mpvc.searchText = cell.textLabel?.text
                }
            }
        }
    }
    
}
