//
//  DetailsViewController.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/1/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var photoModel: Photo!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.kf.setImage(with: photoModel.imageUrl)
        self.title = photoModel.title
    }
    
}
