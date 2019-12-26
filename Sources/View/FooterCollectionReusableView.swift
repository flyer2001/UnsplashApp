//
//  FooterCollectionReusableView.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 26.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import UIKit

class FooterCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var isAnimatingFinal:Bool = false
    var currentTransform:CGAffineTransform?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareInitialAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setTransform(inTransform:CGAffineTransform, scaleFactor:CGFloat) {
         if isAnimatingFinal {
             return
         }
         self.currentTransform = inTransform
        self.activityIndicatorView.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
     }
     
     //reset the animation
     func prepareInitialAnimation() {
         self.isAnimatingFinal = false
         self.activityIndicatorView?.stopAnimating()
         self.activityIndicatorView?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
     }
     
     func startAnimate() {
         self.isAnimatingFinal = true
         self.activityIndicatorView?.startAnimating()
     }
     
     func stopAnimate() {
         self.isAnimatingFinal = false
         self.activityIndicatorView?.stopAnimating()
     }
     
     //final animation to display loading
    func animateFinal() {
         if isAnimatingFinal {
             return
         }
         self.isAnimatingFinal = true
         UIView.animate(withDuration: 0.2) {
             self.activityIndicatorView?.transform = CGAffineTransform.identity
         }
    }
}
