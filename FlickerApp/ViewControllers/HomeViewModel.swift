//
//  HomeViewModel.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/2/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    var photos = [Photo]()
    
    init() {
        loadPhotos()
    }
    
    func loadPhotos() {
        SearchWebService.getLatestLoans(keyword: "kittens", PageNumber: 1) { (result) in
            switch result {
            case .success(let data):
                self.photos = data
            case .failure(let error):
                break
            }
            
        }
    }
    
}
