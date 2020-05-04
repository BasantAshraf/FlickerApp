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
    case serverError
}

class SearchWebService: NSObject {
    
    static func getLatestPhotos(keyword: String, PageNumber: Int, completion: @escaping (Result<Photos, NetworkError>) -> Void) {
        
        let jsonString = Constants.flickrSearchUrl + "&text=\(keyword)" + "&page=\(PageNumber)"
        // addingPercentEncoding is a must to fix the bug of arabic letters
        guard let encodedJsonString = jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedJsonString) else {
            completion(.failure(.badUrl))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                
                guard let data = data else {
                    completion(.failure(.serverError))
                    return
                }
                
                guard let photos = self.parseJsonData(data: data), let photosArray = photos.photo else {
                    completion(.failure(.errorParsingData))
                    return
                }
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
