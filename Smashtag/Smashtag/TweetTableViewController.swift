//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Xingan Wang on 8/2/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK - Model
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            lastTwitterRequest = nil
            searchForTweets()
            title = searchText
        }
    }
    
    // MARK - Fetching Tweets
    private var twitterRequest: Twitter.Request? {
        if lastTwitterRequest == nil {
            if let query = searchText where !query.isEmpty {
                RecentSearch().addSearchTerm(query)
                return Twitter.Request(search: query + " -filter:retweets", count: 100)
            }
        }
        return lastTwitterRequest?.requestForNewer
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak weakSelf = self] newTweets in
                dispatch_async(dispatch_get_main_queue()) {
                    if !newTweets.isEmpty {
                        weakSelf?.tweets.insert(newTweets, atIndex: 0)
                        weakSelf?.updateDatabase(newTweets)
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func updateDatabase(newTweets: [Twitter.Tweet]) {
        managedObjectContext?.performBlock {
            for twitterInfo in newTweets {
                _ = CDTweet.tweetWithTwitterInfo(twitterInfo, withSearchTerm: searchText!, inManagedObjectContext: managedObjectContext)
            }
            (UIApplication.sharedApplication().delegate as? AppDelegate)?.saveContext()
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        searchForTweets()
    }
    
    // MARK - UITableViewDataSource
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.TweetCellIdentifier, forIndexPath: indexPath)
        let tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    // MARK: - Constants
    private struct StoryBoard {
        static let TweetCellIdentifier = "Tweet"
        static let ShowMentionsSegueIdentifier = "showTweetDetailSegue"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == StoryBoard.ShowMentionsSegueIdentifier {
            if let tweetCell = sender as? TweetTableViewCell {
                if (tweetCell.tweet!.hashtags.count +
                    tweetCell.tweet!.urls.count +
                    tweetCell.tweet!.userMentions.count +
                    tweetCell.tweet!.media.count == 0) {
                    return false
                }
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let desvc = segue.destinationViewController as? TweetDetailTableViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case StoryBoard.ShowMentionsSegueIdentifier:
                    if let cell = sender as? TweetTableViewCell {
                        desvc.tweet = cell.tweet
                    }
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}
