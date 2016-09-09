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

    class func mentionWithMentionInfo(mentionInfo: Mention, inManagedObjectContext context: NSManagedObjectContext) -> CDMention? {
        let request = NSFetchRequest(entityName: "CDMention")
        request.predicate = NSPredicate(format: "keyword = %@", mentionInfo.keyword)
        
        if let mention = (try? context.executeFetchRequest(request))?.first as? CDMention {
            return mention
        } else if let mention = NSEntityDescription.insertNewObjectForEntityForName("CDMention", inManagedObjectContext: context) as? CDMention {
            mention.keyword = mentionInfo.keyword
            return mention
        }
        
        return nil
    }
}
