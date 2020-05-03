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
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        scrollView.frame = imageView.frame
        setupScrollView()
        setupDoupleTap()
    }
    
    func setupView() {
        imageView.kf.setImage(with: photoModel.imageUrl)
        imageView.isUserInteractionEnabled = true
        self.title = photoModel.title
    }
    
    func setupScrollView() {
        scrollView.delegate = self
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
            // zoomIn if image is in its minimum scale
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            // zoomOut if image is in its maximum scale
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

extension DetailsViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        zoom(scrollView.zoomScale)
    }
    
    func zoom(_ zoomScale: CGFloat) {
        guard zoomScale >= scrollView.minimumZoomScale, let image = imageView.image else {
            scrollView.contentInset = .zero
            return
        }
        let ratioW = imageView.frame.width / image.size.width
        let ratioH = imageView.frame.height / image.size.height
        
        // take the smaller ratio
        let ratio = ratioW < ratioH ? ratioW: ratioH
        let newWidth = image.size.width * ratio
        let newHeight = image.size.height * ratio
        
        let conditionLeft = newWidth * zoomScale > imageView.frame.width
        let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
        
        let conditionTop = newHeight * zoomScale > imageView.frame.height
        let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
        
        scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
    }
}
