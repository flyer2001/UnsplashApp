//
//  SearchCollectionViewController.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 26.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import UIKit
import Alamofire


class SearchCollectionViewController: UICollectionViewController {
    
    @IBOutlet var searchCollectionView: UICollectionView!
    
    @IBOutlet weak var togglePhotoCollectinsButton: UIBarButtonItem!
    
    // MARK: - Properties
    private let reuseIdentifier = "Cell"
    private let sectionInsets = UIEdgeInsets(top: 10.0,
    left: 10.0,
    bottom: 10.0,
    right: 10.0)
    
    let searchDomain = URL(string: "https://api.unsplash.com/search/photos/" )
    var page = 0
    var params: Parameters = [
        "query": "",
        "page": "1",
        "client_id": "5b5b279313339cd25a6da8948d6670fc10a4ebe987f57c05400503fe645657ce",
        "per_page": "20"
    ]
    
    private var searches: [SearchResults] = []
    //private let flickr = Flickr()
    private let itemsPerRow: CGFloat = 3
    
}

// MARK: - Private
private extension SearchCollectionViewController {
  func photo(for indexPath: IndexPath) -> Photo? {
    return searches[indexPath.section].searchResults.photos?[indexPath.row]
  }
}

// MARK: - Text Field Delegate
extension SearchCollectionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searches = []
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        page = 1
        params["query"] = textField.text
        
        APIService.shared.getObject(url: searchDomain, params: params){
            [weak self] (result: Swift.Result<Search, Error>) in
            activityIndicator.removeFromSuperview()
            do {
                let result = try result.get()
                let searchResults = SearchResults(searchTerm: textField.text ?? "", searchResults: result)
                self?.searches.insert(searchResults, at: 0)
                self?.collectionView.reloadData()
            } catch(let error ) {
                print("\(error)")
            }
    }
    
    textField.text = nil
    textField.resignFirstResponder()
    return true
  }
}

// MARK: - UICollectionViewDataSource
extension SearchCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.photos?.count ?? 0
    }
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath) as! PhotoCollectionViewCell
        let currentPhoto = photo(for: indexPath)
        cell.backgroundColor = .white
        cell.photoImageView.loadPhoto(currentPhoto?.urls?.thumb.absoluteString ?? "", isAnimation: false)
        return cell
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        //print("pullHeight:\(pullHeight)");
        if pullHeight < 0.2 {
            print("load more trigger")
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateNextSet), userInfo: nil, repeats: false)
        }
    }
    
    @objc func updateNextSet(){
        page += 1
        params["page"] = "\(page)"
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        searchCollectionView.addSubview(activityIndicator)
        activityIndicator.frame = CGRect(x: 100.0, y: 100.0, width: 50.0, height: 50.0)
        activityIndicator.startAnimating()
        
        APIService.shared.getObject(url: searchDomain, params: params){
            [weak self] (result: Swift.Result<Search, Error>) in
            do {
                activityIndicator.removeFromSuperview()
                let result = try result.get()
                if let searchText = self?.params["query"] as? String {
                    let searchResults = SearchResults(searchTerm: searchText, searchResults: result)
                    self?.searches.append(searchResults)
                    self?.collectionView.reloadData()
                }
            } catch(let error ) {
                print("\(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC: DetailsViewController = segue.destination as? DetailsViewController {
            if let index = collectionView.indexPathsForSelectedItems?.first {
                if let currentPhoto = searches[index.section].searchResults.photos?[index.row]{
                    destinationVC.sizeOfPhoto = "Size: \(currentPhoto.height ?? 0) x \(currentPhoto.width ?? 0)"
                    destinationVC.desc = "Description: \(currentPhoto.description ?? "")"
                    destinationVC.rawUrlString = currentPhoto.urls?.raw.absoluteString ?? ""
                    destinationVC.thumbUrlString = currentPhoto.urls?.thumb.absoluteString ?? ""
                }
            }
        }
    }

}

extension SearchCollectionViewController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
