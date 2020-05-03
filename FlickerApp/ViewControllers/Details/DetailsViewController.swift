//
//  DetailsViewController.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/1/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, ImageZoomable {
    
    var photoModel: Photo!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScrollView()
        setupDoupleTap()
    }
    
    func setupView() {
        imageView.kf.setImage(with: photoModel.imageUrl, placeholder: Constants.placeholderImage)
        imageView.isUserInteractionEnabled = true
        self.title = photoModel.title
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.frame = imageView.frame
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
    }
    
}

extension DetailsViewController {
    
    func setupDoupleTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        tapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            // zoomIn if image is in its minimum scale, adjust the center to adapt to the touch center
            scrollView.zoom(to: getZoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            // zoomOut if image is in its maximum scale
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
}

extension DetailsViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        zoom(scale: scrollView.zoomScale)
    }

}
