//
//  CollectionOverview.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Foundation

extension Collection {
    
    struct Overview: Decodable {
        let count: Int
        let artObjects: [ArtObject.Short]
    }
}
