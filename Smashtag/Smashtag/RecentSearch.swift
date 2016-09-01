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
        static let ValueKey = "RecentSearch.values"
        static let MaxSearches = 100
    }
    
    private let userDefault = NSUserDefaults.standardUserDefaults()
    
    var values: [String] {
        get {
            return userDefault.stringArrayForKey(Constants.ValueKey) ?? []
        }
        set {
            userDefault.setObject(newValue, forKey: Constants.ValueKey)
        }
    }
    
    func addSearchTerm(searchTerm: String) {
        var currentSearchValues = values
        if let index = currentSearchValues.indexOf(searchTerm) {
            currentSearchValues.removeAtIndex(index)
        }
        currentSearchValues.insert(searchTerm, atIndex: 0)
        while currentSearchValues.count > Constants.MaxSearches {
            currentSearchValues.removeLast()
        }
        values = currentSearchValues
    }
    
    func removeAtIndex(index: Int) {
        var currentSearches = values
        currentSearches.removeAtIndex(index)
        values = currentSearches
    }
    
}