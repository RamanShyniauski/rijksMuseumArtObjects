//
//  OverviewViewModelTests.swift
//  AH-Assignment-MVVMTests
//
//  Created by Roman on 09/07/2022.
//

import XCTest
@testable import AH_Assignment_MVVM

class OverviewViewModelTests: XCTestCase {
    
    var sut: OverviewViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockCoordinator: MockArtObjectsCoordinator!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockCoordinator = MockArtObjectsCoordinator()
        sut = OverviewViewModelImpl(
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
        XCTAssertEqual(sut.state, OverviewViewModelImpl.State.loading)
    }
    
    func testDidLoad_whenSucceeded_stateIsLoaded() {
        goToFetchOverviewFinished()
        XCTAssertEqual(sut.state, OverviewViewModelImpl.State.loaded)
    }
    
    func testDidLoad_whenSucceededWithEmptyResponse_stateIsEmpty() {
        goToFetchOverviewFinished(numberOfPages: 0)
        XCTAssertEqual(sut.state, OverviewViewModelImpl.State.empty)
    }
    
    func testDidLoad_whenFailed_stateIsFailed() {
        let error = NetworkError.unauthorized(nil)
        goToFetchOverviewFailed(with: error)
        XCTAssertEqual(sut.state, OverviewViewModelImpl.State.error(error.localizedDescription))
    }
    
    // MARK: numberOfSections
    
    func testNumberOfSections_whenOverviewIsEmpty_sectionsAreAbsent() {
        goToFetchOverviewFinished(numberOfPages: 0)
        XCTAssertEqual(sut.numberOfSections, 0)
    }
    
    // MARK: onForwardAction
    
    func testOnForwardAction_whenForwardPaginationIsNotAvailable_requestIsNotCalled() {
        goToFetchOverviewFinished(numberOfPages: 0)
        XCTAssertFalse(sut.isForwardPaginationAvailable)
        sut.onForwardAction()
        XCTAssertEqual(mockNetworkManager.requestCalledCounter, 1)
    }
    
    func testOnForwardAction_whenForwardPaginationAvailable_requestIsCalled() {
        goToFetchOverviewFinished()
        XCTAssert(sut.isForwardPaginationAvailable)
        sut.onForwardAction()
        XCTAssertEqual(mockNetworkManager.requestCalledCounter, 2)
    }
    
    func testOnForwardAction_whenForwardPaginationFinished_stateIsLoaded() {
        goToForwardPageFinished()
        XCTAssertEqual(sut.state, OverviewViewModelImpl.State.loaded)
    }
    
    func testOnForwardAction_whenIsLoading_requestIsNotCalled() {
        goToFetchOverviewFinished()
        XCTAssert(sut.isForwardPaginationAvailable)
        sut.onForwardAction()
        XCTAssertEqual(sut.state, OverviewViewModelImpl.State.loading)
        XCTAssert(sut.isForwardPaginationAvailable)
        sut.onForwardAction()
        XCTAssertEqual(mockNetworkManager.requestCalledCounter, 2)
    }
    
    // MARK: onBackAction
    
    func testOnBackAction_whenBackPaginationIsNotAvailable_requestIsNotCalled() {
        goToFetchOverviewFinished(numberOfPages: 0)
        XCTAssertFalse(sut.isBackPaginationAvailable)
        sut.onBackAction()
        XCTAssertEqual(mockNetworkManager.requestCalledCounter, 1)
    }
    
    func testOnBackAction_whenBackPaginationAvailable_requestIsCalled() {
        goToForwardPageFinished()
        XCTAssert(sut.isBackPaginationAvailable)
        sut.onBackAction()
        XCTAssertEqual(mockNetworkManager.requestCalledCounter, 3)
    }
    
    func testOnBackAction_whenBackPaginationFinished_stateIsLoaded() {
        goToForwardPageFinished()
        XCTAssert(sut.isBackPaginationAvailable)
        sut.onBackAction()
        mockNetworkManager.requestOverviewSucceeded()
        XCTAssertEqual(sut.state, OverviewViewModelImpl.State.loaded)
    }
    
    func testOnBackAction_whenIsLoading_requestIsNotCalled() {
        goToForwardPageFinished()
        XCTAssert(sut.isBackPaginationAvailable)
        sut.onBackAction()
        XCTAssertEqual(sut.state, OverviewViewModelImpl.State.loading)
        sut.onBackAction()
        XCTAssertEqual(mockNetworkManager.requestCalledCounter, 3)
    }
    
    // MARK: didSelectItem
    
    func testDidSelectItem_whenIsLoadingState_detailsPageIsNotOpened() {
        goToFetchOverviewFinished()
        XCTAssert(sut.isForwardPaginationAvailable)
        sut.onForwardAction()
        XCTAssertEqual(sut.state, OverviewViewModelImpl.State.loading)
        XCTAssertFalse(mockCoordinator.showDetailsCalled)
    }
    
    func testDidSelectItem_whenItemSelected_detailsPageOpened() {
        let indexPath = IndexPath(row: 0, section: 0)
        goToFetchOverviewFinished()
        sut.didSelectItem(at: indexPath)
        XCTAssert(mockCoordinator.showDetailsCalled)
    }
}

private extension OverviewViewModelTests {
    
    var numberOfItemsPerPage: Int {
        10
    }
    
    func goToFetchOverviewFinished(numberOfPages: Int = 3) {
        if numberOfPages == 0 {
            mockNetworkManager.completeOverview = StubGenerator.stubEmptyOverview()
        } else {
            let numberOfObjects = numberOfPages * numberOfItemsPerPage
            mockNetworkManager.completeOverview = StubGenerator.stubOverview(numberOfObjects: numberOfObjects)
        }
        sut.didLoad()
        mockNetworkManager.requestOverviewSucceeded()
    }
    
    func goToFetchOverviewFailed(with error: Error) {
        sut.didLoad()
        mockNetworkManager.requestOverviewFailed(with: error)
    }
    
    func goToForwardPageFinished() {
        goToFetchOverviewFinished()
        XCTAssert(sut.isForwardPaginationAvailable)
        sut.onForwardAction()
        mockNetworkManager.requestOverviewSucceeded()
    }
}
