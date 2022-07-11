//
//  DetailsViewModel.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 08/07/2022.
//

import Combine
import Foundation

@objc protocol NavigationHandler {
    func onBackButtonAction()
}

protocol DetailsViewModel: NavigationHandler {
    var state: DetailsViewModelImpl.State { get }
    var statePublisher: AnyPublisher<DetailsViewModelImpl.State, Never> { get }
    var imageURL: URL? { get }
    var title: String? { get }
    var description: String? { get }
    func didLoad()
}

class DetailsViewModelImpl: DetailsViewModel {
    
    enum State: Equatable {
        case loading, loaded, error(String)
    }
    
    @Published private(set) var state: State = .loading
    private(set) lazy var statePublisher = $state.eraseToAnyPublisher()
    
    private let objectNumber: String
    private let coordinator: ArtObjectsCoordinator
    private let networkManager: NetworkManager
    
    private var artObject: ArtObject.Full?
    
    var imageURL: URL? {
        if let urlString = artObject?.webImage.url {
            return URL(string: urlString)
        } else {
            return nil
        }
    }
    
    var title: String? {
        artObject?.title
    }
    
    var description: String? {
        artObject?.description
    }
    
    init(objectNumber: String, coordinator: ArtObjectsCoordinator, networkManager: NetworkManager) {
        self.objectNumber = objectNumber
        self.coordinator = coordinator
        self.networkManager = networkManager
    }
    
    func didLoad() {
        let request = Route(.get, .collection(.details(objectNumber)))
        networkManager.request(request) { [weak self] (result: Result<Collection.ObjectDetails, Error>) in
            switch result {
            case .success(let details):
                self?.handleSuccess(details)
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    @objc
    func onBackButtonAction() {
        coordinator.back()
    }
}

private extension DetailsViewModelImpl {
    
    func handleSuccess(_ objectDetails: Collection.ObjectDetails) {
        artObject = objectDetails.artObject
        state = .loaded
    }
    
    func handleError(_ error: Error) {
        // MARK: custom handlers can be added here (e.g. retry button for timedOut, offline message for offline etc)
        if let networkError = error as? NetworkError {
            
        } else if let encodeError = error as? EncodeError {
            
        }
        state = .error(error.localizedDescription)
    }
}
