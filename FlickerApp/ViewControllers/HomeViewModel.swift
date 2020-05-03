//
//  HomeViewModel.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/2/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import Foundation

protocol HomeDelegate {
    func showLoader()
    func hideLoader()
    func didFetchData()
    func errorFetchingData()
    func emptyDataStore()
}

class HomeViewModel {
    
    var photos = [Photo]() {
        didSet {
            delegate.didFetchData()
        }
    }
    var delegate:HomeDelegate
    
    init(delegate: HomeDelegate) {
        self.delegate = delegate
    }
    
    func loadPhotos(keyword: String) {
        delegate.showLoader()
        SearchWebService.getLatestLoans(keyword: keyword, PageNumber: 1) { (result) in
            self.delegate.hideLoader()
            switch result {
            case .success(let data):
                self.photos = data
            case .failure(let error):
                switch error {
                case .badUrl:
                    self.delegate.errorFetchingData()
                case .emptyData:
                    self.delegate.emptyDataStore()
                }
            }
        }
    }
    
}
