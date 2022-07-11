//
//  MockArtObjectsCoordinator.swift
//  AH-Assignment-MVVMTests
//
//  Created by Roman on 09/07/2022.
//

import Foundation
@testable import AH_Assignment_MVVM

class MockArtObjectsCoordinator: ArtObjectsCoordinator {
    
    var showDetailsCalled = false
    var backCalled = false
    
    func start() { }
    
    func showDetails(for objectNumber: String) {
        showDetailsCalled = true
    }
    
    func back() {
        backCalled = true
    }
}
