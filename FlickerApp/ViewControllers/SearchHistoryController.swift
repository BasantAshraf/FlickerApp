//
//  SearchHistoryController.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/1/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

class SearchHistoryController: UIViewController {
    
    var cachedKeyword = [String]() {
        didSet {
            reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let keywords = CacheManager.shared.getCachedKeywords()
        self.cachedKeyword = keywords
    }
    
    func reloadData() {
        print("reload")
    }
}
