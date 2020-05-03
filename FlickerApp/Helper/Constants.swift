//
//  Constants.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/2/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import Foundation

class Constants: NSObject {
    static let api_key = "a4f28588b57387edc18282228da39744"
    static let per_page = 30
    static let flickrSearchUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.api_key)&format=json&nojsoncallback=1&safe_search=1&per_page=\(Constants.per_page)"
}
