//
//  LinksModel.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 26.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import Foundation

public struct ResponseError: Codable {
    
    public let error: String
    public let description: String
    
    private enum CodingKeys: String, CodingKey {
        case error
        case description = "error_description"
    }
}
