//
//  DetailsViewModelTests.swift
//  AH-Assignment-MVVMTests
//
//  Created by Roman on 10/07/2022.
//

import XCTest
@testable import AH_Assignment_MVVM

class DetailsViewModelTests: XCTestCase {

    var sut: DetailsViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockCoordinator: MockArtObjectsCoordinator!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockCoordinator = MockArtObjectsCoordinator()
        sut = DetailsViewModelImpl(
            objectNumber: "testObjectNumber",
            coordinator: mockCoordinator,
            networkManager: mockNetworkManager
        )
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        mockCoordinator = nil
        super.tearDown()
    }
    
    // MARK: didLoad
    
    func testDidLoad_requestIsCalled() {
        sut.didLoad()
        XCTAssert(mockNetworkManager.isRequestCalled)
    }
    
    func testDidLoad_whenInProgress_stateIsLoading() {
        sut.didLoad()
        XCTAssertEqual(sut.state, DetailsViewModelImpl.State.loading)
    }

    func testDidLoad_whenSucceeded_stateIsLoaded() {
        goToFetchDetailsFinished()
        XCTAssertEqual(sut.state, DetailsViewModelImpl.State.loaded)
    }

    func testDidLoad_whenFailed_stateIsFailed() {
        let error = NetworkError.unauthorized(nil)
        goToFetchDetailsFailed(with: error)
        XCTAssertEqual(sut.state, DetailsViewModelImpl.State.error(error.localizedDescription))
    }
    
    // MARK: onBackButtonAction
    
    func testOnBackButtonAction_whenBackTapped_backIsCalled() {
        goToFetchDetailsFinished()
        sut.onBackButtonAction()
        XCTAssert(mockCoordinator.backCalled)
    }
}

private extension DetailsViewModelTests {
    
    func goToFetchDetailsFinished() {
        mockNetworkManager.completeDetails = StubGenerator.stubArtObjectDetails()
        sut.didLoad()
        mockNetworkManager.requestDetailsSucceeded()
    }
    
    func goToFetchDetailsFailed(with error: Error) {
        sut.didLoad()
        mockNetworkManager.requestDetailsFailed(with: error)
    }
}
