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
                                                  withSearchTerm searchText: String,
                                                  inManagedObjectContext context: NSManagedObjectContext) {
        for hashtag in twitterInfo.hashtags {
            _ = addMentionWithKeyword(hashtag.keyword, withSearchTerm: searchText, inManagedObjectContext: context)
        }
        for userMention in twitterInfo.userMentions {
            _ = addMentionWithKeyword(userMention.keyword, withSearchTerm: searchText, inManagedObjectContext: context)
        }
    }
    
    class func addMentionWithKeyword(keyword: String,
                                     withSearchTerm searchText: String,
                                     inManagedObjectContext context: NSManagedObjectContext) -> CDMention? {
        let request = NSFetchRequest(entityName: "CDMention")
        request.predicate = NSPredicate(format: "term.term = %@ and keyword like[cd] %@", searchText, keyword)
        
        if let mention = (try? context.executeFetchRequest(request))?.first as? CDMention {
            mention.count = NSNumber(short: mention.count.shortValue + 1)
            return mention
        } else if let mention = NSEntityDescription.insertNewObjectForEntityForName("CDMention", inManagedObjectContext: context) as? CDMention {
            mention.keyword = keyword
            mention.count = 1
            mention.term = CDSearchTerm.searchTermWithTerm(searchText, inManagedObjectContext: context)
            return mention
        }
        
        return nil
    }
}
