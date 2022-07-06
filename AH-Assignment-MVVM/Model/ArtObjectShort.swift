//
//  ArtObjectShort.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Foundation

struct ArtObjectShort: Decodable {
    
    let id: String
    let objectNumber: String
    let title: String
    let webImage: WebImage
    let hasImage: Bool
    let principalOrFirstMaker: String
    let longTitle: String
    let productionPlaces: [String]
}
