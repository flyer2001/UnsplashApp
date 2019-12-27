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
    public let coverPhoto: Photo?
    public let urls: PhotoURL?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case coverPhoto = "cover_photo"
        case urls
    }
    
}
