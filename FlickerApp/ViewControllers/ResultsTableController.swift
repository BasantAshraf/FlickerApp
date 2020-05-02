//
//  ResultsTableController.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/1/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

class ResultsTableController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let reuseIdentifier = "FlickrCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    }
 
}

// MARK: - Collection View Datasource
extension ResultsTableController: UICollectionViewDataSource, UICollectionViewDelegate {
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
extension ResultsTableController : UICollectionViewDelegateFlowLayout {
    
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
