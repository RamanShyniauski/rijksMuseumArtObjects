//
//  ArtObjectFull.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Foundation

extension ArtObject {
    
    struct Full: Decodable {
        
        let objectNumber: String
        let title: String
        let webImage: WebImage
        let description: String
    }
}
