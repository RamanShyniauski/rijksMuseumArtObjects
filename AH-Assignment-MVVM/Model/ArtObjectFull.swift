//
//  ArtObjectFull.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Foundation

struct ArtObjectFull: Decodable {
    
    let id: String
    let objectNumber: String
    let title: String
    let webImage: WebImage
    let description: String
    let materials: [String]
    let productionPlaces: [String]
    let hasImage: Bool
    let principalOrFirstMaker: String
    let longTitle: String
    let subTitle: String
}
