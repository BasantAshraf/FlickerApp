//
//  HomeViewController.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/1/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var homeViewModel: HomeViewModel!
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let reuseIdentifier = "FlickrCell"
    private var searchController: UISearchController!
    private var searchHistoryController: SearchHistoryController!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupSearchBar()
        collectionView.reloadData()
        print( isActive())
        homeViewModel = HomeViewModel(delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? DetailsViewController, let index = sender as? Int {
            detailsVC.photoModel = homeViewModel.photos[index]
        }
    }
    
    @IBAction func loadMore(_ sender: Any) {
        homeViewModel.loadMore()
    }
    
}

// MARK: -  SearchBar Delegate
extension HomeViewController: UISearchControllerDelegate {
    func isActive() -> Bool {
        return searchController.isActive
    }
    
    func setupSearchBar() {
        searchHistoryController =
            self.storyboard?.instantiateViewController(withIdentifier: "SearchHistoryController") as? SearchHistoryController
        searchHistoryController.delegate = self
        searchController = UISearchController(searchResultsController: searchHistoryController)
        searchController.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}


// MARK: -  SearchBar Delegate, SearchHistoryDelegate
extension HomeViewController: UISearchBarDelegate, SearchHistoryDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        homeViewModel.currentPage = 1
        self.searchController.dismiss(animated: true, completion: nil)
        if let keyword = searchBar.text {
            search(keyword: keyword)
        }
    }
    
    func didSelect(keyword: String) {
        search(keyword: keyword)
    }
    
    func search(keyword: String) {
        CacheManager.shared.cache(keyword: keyword)
        homeViewModel.loadPhotos(keyword: keyword)
    }
}

// MARK: - Collection View Datasource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrCell
        cell.configure(photo: homeViewModel.photos[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "S-DETAILS", sender: indexPath.row)
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

// MARK: - Home Delegate to viewModel
extension HomeViewController: HomeDelegate {
    func showLoader() {
        
    }
    
    func hideLoader() {
        
    }
    
    func emptyDataStore() {
        
    }
    
    func didFetchData() {
        collectionView.reloadData()
    }
    
    func errorFetchingData() {
        
    }
    
}
