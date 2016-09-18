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

    class func tweetWithTwitterInfo(twitterInfo: Tweet,
                                    withSearchTerm search: String,
                                    inManagedObjectContext context: NSManagedObjectContext)
                                    -> CDTweet? {
        let request = NSFetchRequest(entityName: "CDTweet")
        request.predicate = NSPredicate(format: "any terms.term contains[c] %@ and uniqueId = %@", search, twitterInfo.id)
        
        if let tweet = (try? context.executeFetchRequest(request))?.first as? CDTweet {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObjectForEntityForName("CDTweet", inManagedObjectContext: context) as? CDTweet,
                  let term = CDSearchTerm.searchTermWithTerm(search, inManagedObjectContext: context) {
            tweet.uniqueId = twitterInfo.id
            let terms = tweet.mutableSetValueForKey("terms")
            terms.addObject(term)
            _ = CDMention.mentionWithTwitterInfo(twitterInfo, withSearchTerm: search, inManagedObjectContext: context)
            return tweet
        }
        
        return nil
    }
    
}
