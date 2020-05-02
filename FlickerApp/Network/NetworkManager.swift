//
//  NetworkManager.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/2/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

import Foundation

class NetworkManager: NSObject {
    
    private let flickrSearchURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a4f28588b57387edc18282228da39744&format=json&nojsoncallback=1&safe_search=1&per_page=60&text=kittens&page=1"
    private var photos = [Photo]()
    
    func getLatestLoans() {
        guard let loanUrl = URL(string: flickrSearchURL) else {
            return
        }
     
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
     
            if let error = error {
                print(error)
                return
            }
     
            // Parse JSON data
            if let data = data {
                self.photos = self.parseJsonData(data: data)
     
                // Reload table view
                OperationQueue.main.addOperation({
                  ///  self.tableView.reloadData()
                })
            }
        })
     
        task.resume()
    }
    
    private func parseJsonData(data: Data) -> [Photo] {
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
