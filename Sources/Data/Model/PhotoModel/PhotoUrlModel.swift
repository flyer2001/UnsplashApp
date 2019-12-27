//
//  PhotoUrlModel.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 27.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import Foundation

public struct PhotoURL: Codable {
    
    public let raw: URL
    public let full: URL
    public let regular: URL
    public let small: URL
    public let thumb: URL
    public let custom: URL?
}
