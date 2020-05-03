//
//  ImageZoomable.swift
//  FlickerApp
//
//  Created by Bassant Ashraf on 5/3/20.
//  Copyright © 2020 Bassant Ashraf. All rights reserved.
//

import Foundation
import UIKit

protocol ImageZoomable {
    var imageView: UIImageView! { get set }
    var scrollView: UIScrollView! { get set }
    func zoom(scale zoomScale: CGFloat)
    func getZoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect
}
extension ImageZoomable {
    func zoom(scale zoomScale: CGFloat) {
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
    
    func getZoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
}
