//
//  PhotosModel.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 26.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import Foundation

public struct Photo: Codable {
    
    public let width: UInt32?
    public let height: UInt32?
    public let description: String?
    public let urls: PhotoURL?
    
    private enum CodingKeys: String, CodingKey {
        case width
        case height
        case description
        case urls
    }

}


