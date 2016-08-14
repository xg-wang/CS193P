//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Xingan Wang on 8/4/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!

    var tweet: Twitter.Tweet? {
        didSet{
            _updateUI()
        }
    }
    
    private func _updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetCreatedLabel?.text = nil
        tweetProfileImageView?.image = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet {
            let attributedString = NSMutableAttributedString(string: tweet.text)
            let mentionsAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
            for tag in tweet.hashtags {
                attributedString.addAttributes(mentionsAttributes, range: tag.nsrange)
            }
            for userMention in tweet.userMentions {
                attributedString.addAttributes(mentionsAttributes, range: userMention.nsrange)
            }
            for url in tweet.urls {
                attributedString.addAttributes(mentionsAttributes, range: url.nsrange)
            }
            for _ in tweet.media {
                attributedString.appendAttributedString(NSAttributedString(string: " 📷"))
            }
            
            tweetTextLabel?.attributedText = attributedString
            
            
            tweetScreenNameLabel?.text = "\(tweet.user.description)"
            
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                    let contentsOfURL = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()) { [weak weakSelf = self] in
                        if profileImageURL == weakSelf?.tweet?.user.profileImageURL {
                            if let imageData = contentsOfURL {
                                weakSelf?.tweetProfileImageView?.image = UIImage(data: imageData)
                            }
                        } else {
                            print("tweet profile image URL changed, so ignore data.")
                        }
                    }
                }
            }
            
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24 * 60 * 60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
    }
}
