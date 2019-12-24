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

class ViewController: UIViewController {
    var deletePrefix: String?
    @IBOutlet weak var photoOfDay: UIImageView!
    @IBOutlet weak var heightPhotoOfDayConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
    super.viewDidLoad()

    getPhotoOfDay()
    
    }
  
    func getPhotoOfDay() {
        let sourceStringURL = "https://unsplash.com"
        if let sourceURL = URL(string: sourceStringURL){
            let URLTask = URLSession.shared.dataTask(with: sourceURL) {
                myData, response, error in
                guard error == nil else { return }
          
                let myHTMLString = String(data: myData!, encoding: String.Encoding.utf8)

                if let doc = try? HTML(html: myHTMLString ?? "", encoding: .utf8) {
                
                for link in doc.xpath("//a | //link") {
                    if let text = link.text  {
                        if text == "Photo of the Day"{
                            if let photoOfDayString = link["href"]{
                                let resultPhotoOfDay = photoOfDayString.deletingPrefix("/photos/")
                                let resultURLString = "https://source.unsplash.com/" + resultPhotoOfDay
                                self.photoOfDay.loadPhoto(resultURLString)
                                
                                
                            }
                            
                        }
                    }
                    
                }
            }
        
        }
        URLTask.resume()
    }
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
                    
                }
            }
        }
    }
}

// MARK: -deletePrefix
extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
