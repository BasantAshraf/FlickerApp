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
    case errorParsingData
}

class SearchWebService: NSObject {
        
    static func getLatestPhotos(keyword: String, PageNumber: Int, completion: @escaping (Result<Photos, NetworkError>) -> Void) {
        guard let url = URL(string: Constants.flickrSearchUrl + "&text=\(keyword)" + "&page=\(PageNumber)") else {
            return
        }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data else {
                completion(.failure(.badUrl))
                return
            }
            
            guard let photos = self.parseJsonData(data: data), let photosArray = photos.photo else {
                completion(.failure(.errorParsingData))
                return
            }
            DispatchQueue.main.async {
                completion(photosArray.isEmpty ? .failure(.emptyData) : .success(photos))
            }
        })
        task.resume()
    }
    
    private static func parseJsonData(data: Data) -> Photos? {
        var photos: Photos?
        let decoder = JSONDecoder()
        do {
            let photosDataStore = try decoder.decode(PhotosDataStore.self, from: data)
            photos = photosDataStore.photos
        } catch {
            print(error)
        }
        return photos
    }
    
}
