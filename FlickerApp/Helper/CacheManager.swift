//
//  CacheManager.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/4/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let key = "SEARCH_KEYWORDS"
    
    func cache(keyword: String) {
        var cachedKeywords = getCachedKeywords()
        cachedKeywords.append(keyword)
        UserDefaults.standard.set(Array(Set(cachedKeywords)), forKey: key)
    }
    
    func getCachedKeywords() -> [String] {
        var keywords = [String]()
        if let cachedKeywords = UserDefaults.standard.array(forKey: key) as? [String] {
            keywords = cachedKeywords
        }
        return keywords
    }
}
