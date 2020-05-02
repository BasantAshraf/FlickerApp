//
//  HomeViewController.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/1/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

enum HomeViewState {
    case results
    case search
}
// paging
// open details with image + zoom + pinch
// save past search results
// unit test
// uitest
// calling flickr api

class HomeViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
       print( isActive())
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    private var searchController: UISearchController!
    private var resultsTableController: ResultsTableController!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()

        setupSearchBar()
        print( isActive())

    }
    
    func isActive() -> Bool {
        return searchController.isActive
    }
    
    func setupSearchBar() {
        
        resultsTableController =
                  self.storyboard?.instantiateViewController(withIdentifier: "ResultsTableController") as? ResultsTableController
        searchController = UISearchController(searchResultsController: resultsTableController)
         searchController.delegate = self
         searchController.searchResultsUpdater = self
         searchController.searchBar.autocapitalizationType = .none
//         searchController.dimsBackgroundDuringPresentation = false
         searchController.searchBar.delegate = self // Monitor when the search button is tapped.

         // Place the search bar in the navigation bar.
         navigationItem.searchController = searchController
         
         // Make the search bar always visible.
         navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

extension HomeViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "flickrMainCell")
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "S-DETAILS", sender: nil)
    }
    
}
