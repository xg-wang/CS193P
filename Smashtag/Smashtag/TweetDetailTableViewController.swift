//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Xingan Wang on 8/14/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {
    
    // MARK: - Model
    var tweet: Tweet? {
        didSet {
            title = tweet?.user.screenName
            mentions.removeAll()
            if let media = tweet?.media where media.count > 0 {
                mentions.append(Mentions(title: "Images",
                    data: media.map { MentionItem.Image($0.url, $0.aspectRatio) }))
            }
            if let hashtags = tweet?.hashtags where hashtags.count > 0 {
                mentions.append(Mentions(title: "Hashtags",
                    data: hashtags.map { MentionItem.Keyword($0.keyword) }))
            }
            if let urls = tweet?.urls where urls.count > 0 {
                mentions.append(Mentions(title: "Urls",
                    data: urls.map { MentionItem.Keyword($0.keyword) }))
            }
            if let userMentions = tweet?.hashtags where userMentions.count > 0 {
                mentions.append(Mentions(title: "UserMentions",
                    data: userMentions.map { MentionItem.Keyword($0.keyword) }))
            }
            tableView.reloadData()
        }
    }
    
    struct Mentions: CustomStringConvertible {
        var title: String
        var data: [MentionItem]
        var description: String { return "\(title): \(data)" }
    }
    
    enum MentionItem: CustomStringConvertible {
        case Keyword(String)
        case Image(NSURL, Double)
        
        var description: String {
            switch self {
            case .Keyword(let keyword):
                return keyword
            case .Image(let url, _):
                return "\(url.path)"
            }
        }
    }
    
    var mentions: [Mentions] = []

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].title
    }
    
    private struct StoryBoard {
        static let imageIdentifier          = "image"
        static let mentionIdentifier        = "mention"
        static let keywordSegueIdentifier   = "SearchKeywordSegue"
        static let imageSegueIdentifier     = "ShowImageSegue"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.mentionIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.imageIdentifier, forIndexPath: indexPath)
            if let imageCell = cell as? TweetImageTableViewCell {
                imageCell.imageUrl = url
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.frame.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == StoryBoard.keywordSegueIdentifier {
            if let cell = sender as? UITableViewCell {
                if let url = NSURL(string: cell.textLabel?.text ?? "") where UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                    return false
                }
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case StoryBoard.keywordSegueIdentifier:
                if let ttvc = segue.destinationViewController as? TweetTableViewController {
                    if let cell = sender as? UITableViewCell {
                        ttvc.searchText = cell.textLabel?.text
                    }
                }
            case StoryBoard.imageSegueIdentifier:
                if let imgvc = segue.destinationViewController as? ImageViewController {
                    if let cell = sender as? TweetImageTableViewCell {
                        if let img = cell.tweetImage.image {
                            imgvc.image = img
                        } else {
                            imgvc.imageURL = cell.imageUrl
                        }
                        imgvc.title = title
                    }
                }
            default:
                break
            }
        }
    }

}
