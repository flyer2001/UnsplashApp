//
//  UnsplashPhotoModel.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 25.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker

extension UnsplashPhoto{
    var description: String? {return ""}
    
    enum CodingKeysExt: String, CodingKey {
        case description
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeysExt.self)
        
        //print("DESCRIPTION IS!!!\(desc)")
        //self.description = try container.decode(String.self, forKey: .description)
        try self.init(from: decoder)
        description = try container.decode(String.self, forKey: .description)
    }
    
}
