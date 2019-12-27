//
//  SearchResults.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 26.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import Foundation

struct SearchResults {
  let searchTerm: String?
  let searchResults: Search?
  let collections: [Collection?]
}

struct CollectionIdSearchResult {
    let photos: [Photo]
}
