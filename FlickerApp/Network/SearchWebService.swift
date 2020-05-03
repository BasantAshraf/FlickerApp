//
//  SearchWebService.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/2/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

import Foundation

enum NetworkError: Error {
    case badUrl
}

class SearchWebService: NSObject {
        
    private static let flickrSearchURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a4f28588b57387edc18282228da39744&format=json&nojsoncallback=1&safe_search=1&per_page=30"

    
    // text, pageNum
    static func getLatestLoans(keyword: String, PageNumber: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        guard let loanUrl = URL(string: flickrSearchURL + "&text=\(keyword)" + "&page=\(PageNumber)") else {
            return
        }
     
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in

            guard let data = data else {
                completion(.failure(.badUrl))
                return
            }
                    
            let photos = self.parseJsonData(data: data)
            completion(.success(photos))
        })
        task.resume()
    }
    
    private static func parseJsonData(data: Data) -> [Photo] {
        var photos = [Photo]()
        let decoder = JSONDecoder()
        do {
            let photosDataStore = try decoder.decode(PhotosDataStore.self, from: data)
            photos = photosDataStore.photos?.photo ?? []
        } catch {
            print(error)
        }
        return photos
    }

}
