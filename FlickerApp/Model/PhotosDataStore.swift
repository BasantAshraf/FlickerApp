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
    
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
        case stat = "stat"
    }
}

struct Photos: Codable {
    let page: Int
    let pages : Int
    let photo : [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case photo = "photo"
    }
}

struct Photo : Codable {
    let id : String
    let secret : String
    let server : String
    let farm : Int
    let title : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case secret = "secret"
        case server = "server"
        case farm = "farm"
        case title = "title"
    }
    
    // https://www.flickr.com/services/api/misc.urls.html?PHPSESSID=5af01f8ca48c716e98ee49a51ed2ff35
    var imageUrl: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
    }
}
