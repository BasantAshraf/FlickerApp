//
//  SearchHistoryController.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/1/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

protocol SearchHistoryDelegate {
    func didSelect(keyword: String)
}

class SearchHistoryController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: SearchHistoryDelegate!
    
    var cachedKeyword = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let keywords = CacheManager.shared.getCachedKeywords()
        self.cachedKeyword = keywords
    }
    
}

extension SearchHistoryController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cachedKeyword.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let keyword = cachedKeyword[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell.textLabel?.text = keyword
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedKeyword = cachedKeyword[indexPath.row]
        delegate.didSelect(keyword: selectedKeyword)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
