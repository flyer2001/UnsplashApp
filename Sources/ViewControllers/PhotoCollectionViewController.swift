//
//  PhotoCollectionViewController.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 27.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import UIKit



class PhotoCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "CellPhotoCollectionID"
    var collectionsId = ""
    
    private var searches: [CollectionIdSearchResult] = []
    private let itemsPerRow: CGFloat = 3
    var collectionIDSearchDomain = URL(string: domainAPI)?.appendingPathComponent(collectionsUrlEndPoint)
    var page = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(collectionsId)
        params["collections"] = collectionsId
        collectionIDSearchDomain = collectionIDSearchDomain?.appendingPathComponent("/\(collectionsId)/photos/")
        getSearchFromAPI()
    }

}

//// MARK: - Private
private extension PhotoCollectionViewController {
    func photo(for indexPath: IndexPath) -> Photo? {
        return searches[indexPath.section].photos[indexPath.row]
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoCollectionViewController {
    
    func getSearchFromAPI(){
        APIService.shared.getObject(url: collectionIDSearchDomain, params: params){
            [weak self] (result: Swift.Result<[Photo], Error>) in
            do {
                let result = try result.get()
                print(result.count)
                print(self?.collectionIDSearchDomain)
                let searchResults = CollectionIdSearchResult(photos: result)
                self?.searches.append(searchResults)
                self?.collectionView.reloadData()
            } catch(let error ) {
                print("\(error)")
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].photos.count
    }
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath) as! CollectionIdCollectionViewCell
        let currentPhoto = photo(for: indexPath)
        cell.backgroundColor = .white
        cell.imageView.loadPhoto(currentPhoto?.urls?.thumb.absoluteString ?? "", isAnimation: false)
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
        getSearchFromAPI()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        performSegue(withIdentifier: "collectionPhotoIdDetailsSegue", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC: DetailsViewController = segue.destination as? DetailsViewController {
            if let index = collectionView.indexPathsForSelectedItems?.first {
                let currentPhoto = searches[index.section].photos[index.row]
                destinationVC.sizeOfPhoto = "Size: \(currentPhoto.height ?? 0) x \(currentPhoto.width ?? 0)"
                destinationVC.desc = "Description: \(currentPhoto.description ?? "")"
                destinationVC.rawUrlString = currentPhoto.urls?.raw.absoluteString ?? ""
                destinationVC.thumbUrlString = currentPhoto.urls?.thumb.absoluteString ?? ""
                
            }
        }
    }

}

extension PhotoCollectionViewController : UICollectionViewDelegateFlowLayout {
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
