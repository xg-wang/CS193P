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


class CDTweet: NSManagedObject {

//    class func tweetWithTwitterInfo(twitterInfo: Tweet, inManagedObjectContext context: NSManagedObjectContext) -> CDTweet? {
//        let request = NSFetchRequest(entityName: "CDTweet")
//        request.predicate = NSPredicate(format: "uniqueId = %@", twitterInfo.id)
//        
//        if let tweet = (try? context.executeFetchRequest(request))?.first as? CDTweet {
//            return tweet
//        } else if let tweet = NSEntityDescription.insertNewObjectForEntityForName("CDTweet", inManagedObjectContext: context) as? CDTweet {
//            tweet.uniqueId = twitterInfo.id
//            tweet.mentions = NSSet.setByAddingObjectsFromArray(<#T##NSSet#>)
//            for hashtag in twitterInfo.hashtags {
//                tweet.mentions?.setByAddingObject(CDMention.mentionWithMentionInfo(hashtag, inManagedObjectContext: context))
//            }
//        }
//    }
}
