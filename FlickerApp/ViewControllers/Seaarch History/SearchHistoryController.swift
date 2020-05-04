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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    func updateView() {
        let keywords = CacheManager.shared.getCachedKeywords()
        self.cachedKeyword = keywords
    }
    
}

//MARK: make table scrollable above keyboard
extension SearchHistoryController {
    @objc func keyboardWillShow(_ notification:Notification) {
        updateView()
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

//MARK: Table datasource and delegate
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
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedKeyword = cachedKeyword[indexPath.row]
        delegate.didSelect(keyword: selectedKeyword)
        self.dismiss(animated: true, completion: nil)
    }
    
}
