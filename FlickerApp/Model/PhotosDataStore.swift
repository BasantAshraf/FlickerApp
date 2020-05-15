//
//  PhotosDataStore.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/2/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import Foundation

struct PhotosDataStore : Codable {
    let photos : Photos?
    let stat : String?
    
//    enum CodingKeys: String, CodingKey {
//        case photos = "photos"
//        case stat = "stat"
//    }
}

struct Photos: Codable {
    let page: Int
    let pages : Int
    let photo : [Photo]?
}

struct Photo : Codable {
    let id : String
    let secret : String
    let server : String
    let farm : Int
    let title : String?
    
    // https://www.flickr.com/services/api/misc.urls.html?PHPSESSID=5af01f8ca48c716e98ee49a51ed2ff35
    var imageUrl: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
    }
}
