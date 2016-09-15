//
//  CDTweet.swift
//  Smashtag
//
//  Created by Xingan Wang on 9/9/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import Foundation
import CoreData
import Twitter


class CDMention: NSManagedObject {

    class func mentionWithTwitterInfo(twitterInfo: Tweet,
                                      withSearchTerm search: String,
                                      inManagedObjectContext context: NSManagedObjectContext) -> CDMention? {
        
        
    }
    
    class func addMentionWithKeyword() {
        let request = NSFetchRequest(entityName: "CDMention")
        // TODO!
                                        
        request.predicate = NSPredicate(format: "keyword = %@", mentionInfo.keyword)
        
        if let mention = (try? context.executeFetchRequest(request))?.first as? CDMention {
            if let uniqueIds = mention.tweets?.allObjects as? [String] where !(uniqueIds.contains(tweet.id)) {
                mention.tweets?.setByAddingObject(CDTweet.tweetWithTwitterInfo(tweet, inManagedObjectContext: context))
                mention.count += 1
            }
            return mention
        } else if let mention = NSEntityDescription.insertNewObjectForEntityForName("CDMention", inManagedObjectContext: context) as? CDMention {
            mention.keyword = mentionInfo.keyword
            mention.count = 1
            mention.tweets?.setByAddingObject(CDTweet.tweetWithTwitterInfo(tweet, withSearchTerm: search, inManagedObjectContext: context))
            return mention
        }
        
        return nil
    }
}
