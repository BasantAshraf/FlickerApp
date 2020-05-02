//
//  HomeViewController.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/1/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

enum HomeViewState {
    case loading
    case noInternet
    case empty
    case results
}
// paging
// open details with image + zoom + pinch
// save past search results
// unit test
// uitest
// calling flickr api
// remove scene delegate
// Result introduced in swift 5
// animation transition from results to details
//  constant file + image url + api key
// custom cell
// read me file
// MARK

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

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
        callApi()
    }
    
    func callApi() {
        NetworkManager().getLatestLoans()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

// MARK: -  SearchBar Delegate
extension HomeViewController: UISearchControllerDelegate, UISearchResultsUpdating {

    func isActive() -> Bool {
        return searchController.isActive
    }
    
    func setupSearchBar() {
         
         searchHistoryController =
             self.storyboard?.instantiateViewController(withIdentifier: "SearchHistoryController") as? SearchHistoryController
         searchController = UISearchController(searchResultsController: searchHistoryController)
         searchController.delegate = self
         searchController.searchResultsUpdater = self
         searchController.searchBar.autocapitalizationType = .none
         //         searchController.dimsBackgroundDuringPresentation = false
         searchController.searchBar.delegate = self
         navigationItem.searchController = searchController
         navigationItem.hidesSearchBarWhenScrolling = false
     }
    
    func updateSearchResults(for searchController: UISearchController) {
        print( isActive())
    }
    
}


// MARK: -  SearchBar Delegate
extension HomeViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

// MARK: - Collection View Datasource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .black      //  cell.photoModel =
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "S-DETAILS", sender: nil)
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
