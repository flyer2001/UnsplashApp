//
//  DetailsViewController.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 26.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var sizeOfPhoto = ""
    var desc = ""
    var rawUrlString = ""
    var thumbUrlString = ""
    
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rawUrlTextField: UITextField!
    @IBOutlet weak var photoDetailsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizeLabel.text = sizeOfPhoto
        descriptionLabel.text = desc
        rawUrlTextField.text = rawUrlString
        photoDetailsImageView.loadPhoto(thumbUrlString, isAnimation: true)
    }
    
    @IBAction func copyToClipboardButton(_ sender: Any) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = rawUrlTextField.text
    }
    
}
