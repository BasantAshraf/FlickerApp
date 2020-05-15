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
    private var numberOfPages: Int = 1
    private var keyword: String = ""
    private var hasReachedEndResults: Bool {
        return currentPage == numberOfPages
    }
    
    init(delegate: HomeDelegate) {
        self.delegate = delegate
    }
    
    func loadPhotos(keyword: String) {
        if self.currentPage == 1 {
            delegate.showLoader()
        }
        SearchWebService.getLatestPhotos(keyword: keyword, PageNumber: currentPage) { [weak self] (result) in
            self?.delegate.hideLoader()
            switch result {
            case .success(let data):
                self?.handleServiceSuccess(data, keyword: keyword)
            case .failure(let error):
                self?.handleServiceError(error)
            }
        }
    }
    
    fileprivate func handleServiceSuccess(_ data: Photos, keyword: String) {
        let photoResults = data.photo ?? []
        if self.currentPage == 1 {
            self.keyword = keyword
            self.numberOfPages = data.pages
            self.photos = photoResults
        } else {
            // append results if load more, not the first page
            self.photos.append(contentsOf: photoResults)
        }
    }
    
    fileprivate func handleServiceError(_ error: NetworkError) {
        self.photos = []
        switch error {
        case .badUrl, .errorParsingData, .serverError:
            self.delegate.errorFetchingData()
        case .emptyData:
            self.delegate.emptyDataStore()
        }
    }
    
    func loadMore() {
        if !hasReachedEndResults {
            currentPage += 1
            loadPhotos(keyword: keyword)
        }
    }
    
}
