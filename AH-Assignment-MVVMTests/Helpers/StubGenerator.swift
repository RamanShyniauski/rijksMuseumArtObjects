//
//  StubGenerator.swift
//  AH-Assignment-MVVMTests
//
//  Created by Roman on 10/07/2022.
//

import Foundation
@testable import AH_Assignment_MVVM

struct StubGenerator {
    
    static func stubEmptyOverview() -> Collection.Overview {
        Collection.Overview(count: 0, artObjects: [])
    }
    
    static func stubOverview(numberOfObjects: Int) -> Collection.Overview {
        var artObjects = [ArtObject.Short]()
        for i in 0..<numberOfObjects {
            artObjects.append(
                ArtObject.Short(
                    objectNumber: "\(i)",
                    title: "Test Object \(i)",
                    webImage: ArtObject.WebImage(url: "test-url-\(i)"),
                    principalOrFirstMaker: "Test Maker \(i)"
                )
            )
        }
        return Collection.Overview(
            count: numberOfObjects,
            artObjects: artObjects
        )
    }
    
    static func stubArtObjectDetails() -> Collection.ObjectDetails {
        Collection.ObjectDetails(
            artObject: ArtObject.Full(
                objectNumber: "testArtObjectFull",
                title: "Test Art Object Full Title",
                webImage: ArtObject.WebImage(url: "test-art-object-full-url"),
                description: "Test Art Object Full Description"
            )
        )
    }
}
