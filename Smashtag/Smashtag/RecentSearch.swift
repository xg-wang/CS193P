//
//  RecentSearch.swift
//  Smashtag
//
//  Created by Xingan Wang on 8/31/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import Foundation

class RecentSearch {
    
    private struct Constants {
        static let ValueKey = "RecentSearch.Values"
        static let MaxSearches = 100
    }
    
    private let userDefault = NSUserDefaults.standardUserDefaults()
    
    var Values: [String] {
        get {
            return userDefault.stringArrayForKey(Constants.ValueKey) ?? []
        }
        set {
            userDefault.setObject(newValue, forKey: Constants.ValueKey)
        }
    }
    
    func addSearchTerm(searchTerm: String) {
        var currentSearchValues = Values
        if let index = currentSearchValues.indexOf(searchTerm) {
            currentSearchValues.removeAtIndex(index)
        }
        currentSearchValues.insert(searchTerm, atIndex: 0)
        while currentSearchValues.count > Constants.MaxSearches {
            currentSearchValues.removeLast()
        }
        Values = currentSearchValues
    }
    
}