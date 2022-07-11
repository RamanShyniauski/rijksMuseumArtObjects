//
//  MockNetworkManager.swift
//  AH-Assignment-MVVMTests
//
//  Created by Roman on 09/07/2022.
//

import Alamofire
import Foundation
@testable import AH_Assignment_MVVM

class MockNetworkManager: NetworkManager {
    
    var isRequestCalled = false
    var requestCalledCounter = 0
    
    var completeOverviewClosure: ((Result<Collection.Overview, Error>) -> Void)!
    var completeDetailsClosure: ((Result<Collection.ObjectDetails, Error>) -> Void)!
    
    var completeOverview: Collection.Overview = StubGenerator.stubEmptyOverview()
    var completeDetails: Collection.ObjectDetails = StubGenerator.stubArtObjectDetails()
    
    func request<Response: Decodable>(
        _ request: URLRequestConvertible,
        completion: @escaping (Result<Response, Error>) -> Void
    ) {
        isRequestCalled = true
        requestCalledCounter += 1
        completeOverviewClosure = completion as? ((Result<Collection.Overview, Error>) -> Void)
        completeDetailsClosure = completion as? ((Result<Collection.ObjectDetails, Error>) -> Void)
    }
    
    func requestOverviewSucceeded() {
        completeOverviewClosure(.success(completeOverview))
    }
    
    func requestOverviewFailed(with error: Error) {
        completeOverviewClosure(.failure(error))
    }
    
    func requestDetailsSucceeded() {
        completeDetailsClosure(.success(completeDetails))
    }
    
    func requestDetailsFailed(with error: Error) {
        completeDetailsClosure(.failure(error))
    }
}
