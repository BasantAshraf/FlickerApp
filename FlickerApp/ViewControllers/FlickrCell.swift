//
//  FlickrCell.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/2/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

class FlickrCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var photoModel: Photo? {
        didSet {
            guard photoModel != nil else {
                return
            }
        }
       // imageView.image = 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFit
    }

}
