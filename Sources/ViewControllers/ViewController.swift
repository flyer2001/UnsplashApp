//
//  ViewController.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 24.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker
import Kanna

let homePageUnsplash = "https://unsplash.com"
let sourceUnslpash = "https://source.unsplash.com/"
let filterText = "Photo of the Day"

class ViewController: UIViewController {
    
    @IBOutlet weak var photoOfDayImageView: UIImageView!
    @IBOutlet weak var welcomeScreenTextLabel: UILabel!
    @IBOutlet weak var welcomeView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeScreenTextLabel.blink()
        getPhotoOfDay()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(oneTap))
        tap.numberOfTapsRequired = 1
        welcomeView.addGestureRecognizer(tap)
    }
    
    func getPhotoOfDay(){
        APIService.shared.parsingStringFromHTML(url: URL(string: homePageUnsplash), filterText: filterText){
            [weak self](result: Swift.Result<[String], Error>) in
            do {
                if let result = try result.get().first {
                    let resultPhotoOfDay = result.deletingPrefix("/photos/")
                    let resultURLString = sourceUnslpash + resultPhotoOfDay
                    self?.photoOfDayImageView.loadPhoto(resultURLString)
                }
                
            } catch (let error) {
                print("\(error)")
            }
        }
    }
    
    @objc func oneTap() {
        welcomeView.disappearAndRemovView()
    }

}


//MARK: - UIView
extension UIView{
     func blink() {
         self.alpha = 0.2
         UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
     }
    
    func disappearAndRemovView(){
        UIView.self.animate(withDuration: 1, animations: {self.alpha = 0.0}, completion: {(value: Bool) in
            self.removeFromSuperview()
        })
    }
}

//MARK: -UIIMageView

extension UIImageView {
    func loadPhoto(_ url: String) {
        let photoUrl = URL(string: url)
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: photoUrl!), let image = UIImage(data: data) {
                    self.image = image
                    self.alpha = 0.0
                    UIViewPropertyAnimator(duration: 2.0, curve: .easeIn, animations: {
                        self.alpha = 1.0
                    }).startAnimation()
                }
                    
                }
        }
    }
}


extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

// MARK: -deletePrefix
extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
