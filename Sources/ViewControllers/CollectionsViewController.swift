//
//  CollectionsViewController.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 27.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import UIKit

class CollectionsViewController: UICollectionViewController {
    private let reuseIdentifier = "CellCollections"
    private var searches: [SearchResults] = []
        let collectionsDomain = URL(string: domainAPI)?.appendingPathComponent(collectionsUrlEndPoint)
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsPerRow = 1
        searches = []
        getCollections()
    }
}

private extension CollectionsViewController {
    func photo(for indexPath: IndexPath) -> Photo? {
        return searches[indexPath.section].collections[indexPath.row]?.coverPhoto
    }
}

extension CollectionsViewController {
    @objc func getCollections(){
        params["query"] = ""
        page += 1
        params["page"] = "\(page)"
        APIService.shared.getObject(url: collectionsDomain, params: params){
            [weak self] (result: Swift.Result<[Collection], Error>) in
            do {
                let result = try result.get()
                let searchResults = SearchResults(searchTerm: nil, searchResults: nil, collections: result)
                self?.searches.insert(searchResults, at: 0)
                self?.collectionView.reloadData()
            } catch(let error ) {
                print("\(error)")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionsViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].collections.count
    }
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath) as! CollectionsViewCell
        let currentPhoto = photo(for: indexPath)
        let currentCollection = searches.first?.collections[indexPath.row]
        cell.backgroundColor = .white
        cell.collectionsImageView.loadPhoto(currentPhoto?.urls?.thumb.absoluteString ?? "", isAnimation: false)
        cell.collectionTitleLabel.text = currentCollection?.title
        return cell
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        let pullHeight  = abs(diffHeight - frameHeight)
        if pullHeight < 0.2 {
            print("load more")
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getCollections), userInfo: nil, repeats: false)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        performSegue(withIdentifier: "toSearchCollectionPhoto", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC: PhotoCollectionViewController = segue.destination as? PhotoCollectionViewController {
            if let index = collectionView.indexPathsForSelectedItems?.first {
                if let currentCollection = searches[index.section].collections[index.row]{
                    destinationVC.collectionsId = "\(currentCollection.id)"
                }
            }
        }
    }
}

