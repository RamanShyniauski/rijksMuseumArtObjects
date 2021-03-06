//
//  Collection+Endpoint.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Foundation

extension Endpoint {

    static func collection(_ collection: Collection) -> Endpoint {
        .rijksMuseum(path: collection.path)
    }

    enum Collection {
        case overview
        case details(String)

        var path: String {
            switch self {
            case .overview:
                return "collection"
            case .details(let objectNumber):
                return "collection/" + objectNumber
            }
        }
    }
}
