//
//  CollectionsModel.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 26.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import Foundation

public struct Collection: Codable {
    
    public let id: UInt32
    public var title: String
    //public var description: String?
    //public let curated: Bool?
    //public let featured: Bool?
    //public var isPrivate: Bool?
    //public let shareKey: String?
    public let coverPhoto: Photo?
    //public let publishedAt: Date
    //public let user: User?
    //public let totalPhotos: UInt32?
    public let urls: PhotoURL?
    //public let categories: [Category]?
    //public let links: Links?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        //case description
        //case curated
        //case featured
        //case isPrivate = "private"
        //case shareKey = "share_key"
        case coverPhoto = "cover_photo"
        //case publishedAt = "published_at"
        //case user
        //case totalPhotos = "total_photos"
        case urls
        //case categories
        //case links
    }
    
}

public struct CollectionPhotoUpdate: Codable {
    
    public let photo: Photo
    public let collection: Collection
    //public let user: User
    
}
