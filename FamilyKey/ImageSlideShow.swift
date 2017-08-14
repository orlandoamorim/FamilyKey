//
//  ImageSlideShow.swift
//  FamilyKey
//
//  Created by Orlando Amorim on 02/06/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import UIKit

import ImageSlideshow

protocol ImageSlideShowDelegate {
    func slideShowTapped(cell: ImageSlideShow)
}

class ImageSlideShow: UIView {
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    var delegate: ImageSlideShowDelegate?
    
    func cellTapped(sender: AnyObject) {
        delegate?.slideShowTapped(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 3.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
        slideshow.pageControl.pageIndicatorTintColor = UIColor(red: 43.0/255.0, green: 163.0/255.0, blue: 67.0/255.0, alpha: 1.0)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        slideshow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ImageSlideShow.cellTapped)))
        
    }
}
