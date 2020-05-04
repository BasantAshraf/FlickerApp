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
    var currentPage:Int = 1
    var numberOfPages: Int = 1
    var keyword: String = ""
    var hasReachedEndResults: Bool {
        return currentPage == numberOfPages
    }
    
    init(delegate: HomeDelegate) {
        self.delegate = delegate
    }
    
    func loadPhotos(keyword: String) {
        delegate.showLoader()
        SearchWebService.getLatestPhotos(keyword: keyword, PageNumber: currentPage) { (result) in
            self.delegate.hideLoader()
            switch result {
            case .success(let data):
                let photoResults = data.photo ?? []
                if self.currentPage == 1 {
                    self.keyword = keyword
                    self.numberOfPages = data.pages
                    self.photos = photoResults
                } else {
                    // append results if load more, not the first page
                    self.photos.append(contentsOf: photoResults)
                }
            case .failure(let error):
                switch error {
                case .badUrl, .errorParsingData:
                    self.delegate.errorFetchingData()
                case .emptyData:
                    self.delegate.emptyDataStore()
                }
            }
        }
    }
    
    func loadMore() {
        if !hasReachedEndResults {
            currentPage += 1
            loadPhotos(keyword: keyword)
        }
    }
    
}
