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
    case emptyData
}

class SearchWebService: NSObject {
        
    static func getLatestLoans(keyword: String, PageNumber: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        guard let url = URL(string: Constants.flickrSearchUrl + "&text=\(keyword)" + "&page=\(PageNumber)") else {
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data else {
                completion(.failure(.badUrl))
                return
            }
            
            let photos = self.parseJsonData(data: data)
            DispatchQueue.main.async {
                completion(photos.isEmpty ? .failure(.emptyData) : .success(photos))
            }
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
