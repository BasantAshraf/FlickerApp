//
//  HomeViewController.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/1/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

enum screenState {
    case emptyData
    case results
    case searching
}

class HomeViewController: UIViewController {
    
    var alert: UIAlertController!
    
    @IBOutlet weak var searchHistoryContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var homeViewModel: HomeViewModel!
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let reuseIdentifier = "FlickrCell"
    private var searchBar = UISearchBar()
    private var searchHistoryViewController: SearchHistoryController!

    var currentState: screenState = .emptyData {
        didSet {
            var isResultsHidden = false
            var isSearchingHidden = false
            
            switch currentState {
            case .emptyData:
                isResultsHidden = true
                isSearchingHidden = true
            case .results:
                isResultsHidden = false
                isSearchingHidden = true
            case .searching:
                isResultsHidden = true
                isSearchingHidden = false
            }
            
            UIView.animate(withDuration: 1) {
                self.collectionView.isHidden = isResultsHidden
                self.searchHistoryContainerView.isHidden = isSearchingHidden
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupSearchBar()
        showEmptyScreen()
        homeViewModel = HomeViewModel(delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? DetailsViewController, let index = sender as? Int {
            detailsVC.photoModel = homeViewModel.photos[index]
        } else if let searchHistoryVC = segue.destination as? SearchHistoryController {
            searchHistoryVC.delegate = self
            searchHistoryViewController = searchHistoryVC
        }
    }

}

// MARK: -  SearchBar Delegate, SearchHistoryDelegate
extension HomeViewController: UISearchBarDelegate, SearchHistoryDelegate{
    
    func setupSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search any keyword"
        searchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        currentState = .searching
        searchHistoryViewController.updateView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            search(keyword: keyword)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentState = .results
        searchBar.searchTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func didSelect(keyword: String) {
        searchBar.text = keyword
        search(keyword: keyword)
    }
    
    func search(keyword: String) {
        homeViewModel.currentPage = 1
        currentState = .results
        searchBar.searchTextField.resignFirstResponder()
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == homeViewModel.photos.count - 1 {
            homeViewModel.loadMore()
        }
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
        alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func hideLoader() {
        alert.dismiss(animated: true, completion: nil)
    }
    
    func emptyDataStore() {
        showEmptyScreen()
    }
    
    func didFetchData() {
        collectionView.backgroundView = nil
        collectionView.reloadData()
    }
    
    func showEmptyScreen() {
        let errorView = UIImageView(image: UIImage(named: "emptyState"))
        errorView.contentMode = .scaleAspectFit
        collectionView.backgroundView = errorView
    }
    
    func errorFetchingData() {
        showEmptyScreen()
        let alert = UIAlertController(title: "Something went wrong, please try again", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
