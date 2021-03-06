//
//  OverviewViewModel.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Combine
import Foundation

protocol OverviewViewModel {
    var state: OverviewViewModelImpl.State { get }
    var statePublisher: AnyPublisher<OverviewViewModelImpl.State, Never> { get }
    var numberOfSections: Int { get }
    var isBackPaginationAvailable: Bool { get }
    var isForwardPaginationAvailable: Bool { get }
    var paginationLabelText: String { get }
    func titleForSection(_ section: Int) -> String
    func numberOfRows(in section: Int) -> Int
    func cellModel(at indexPath: IndexPath) -> OverviewCollectionViewCellModel
    func didLoad()
    func didSelectItem(at indexPath: IndexPath)
    func onForwardAction()
    func onBackAction()
}

class OverviewViewModelImpl: OverviewViewModel {
    
    enum State: Equatable {
        case loading, loaded, empty, error(String)
    }
    
    @Published private(set) var state: State = .loading
    private(set) lazy var statePublisher = $state.eraseToAnyPublisher()
    
    private let coordinator: ArtObjectsCoordinator
    private let networkManager: NetworkManager
    
    private let resultsPerPage = 10
    private var currentPage = 1
    private var objectsTotalCount = 0
    private var pagesAvailable: Int {
        Int((Double(objectsTotalCount) / Double(resultsPerPage)).rounded(.up))
    }
    
    private var sections: [OverviewSection] = []
    
    var numberOfSections: Int {
        sections.count
    }
    
    var isBackPaginationAvailable: Bool {
        currentPage > 1
    }
    
    var isForwardPaginationAvailable: Bool {
        currentPage < pagesAvailable
    }
    
    var paginationLabelText: String {
        "\(currentPage) page of \(pagesAvailable) pages"
    }
    
    init(coordinator: ArtObjectsCoordinator, networkManager: NetworkManager) {
        self.coordinator = coordinator
        self.networkManager = networkManager
    }
    
    func didLoad() {
        loadOverview()
    }
    
    func titleForSection(_ section: Int) -> String {
        sections[section].name
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard state == .loaded else { return }
        let artObjectNumber = cellModel(at: indexPath).objectNumber
        coordinator.showDetails(for: artObjectNumber)
    }
    
    func numberOfRows(in section: Int) -> Int {
        sections[section].cells.count
    }
    
    func cellModel(at indexPath: IndexPath) -> OverviewCollectionViewCellModel {
        sections[indexPath.section].cells[indexPath.row]
    }
    
    func onBackAction() {
        guard isBackPaginationAvailable, state == .loaded else { return }
        currentPage -= 1
        state = .loading
        loadOverview()
    }
    
    func onForwardAction() {
        guard isForwardPaginationAvailable, state == .loaded else { return }
        currentPage += 1
        state = .loading
        loadOverview()
    }
}

private extension OverviewViewModelImpl {
    
    func loadOverview() {
        let params = ["ps": resultsPerPage, "p": currentPage]
        let request = Route(.get, .collection(.overview), with: params)
        networkManager.request(request) { [weak self] (result: Result<Collection.Overview, Error>) in
            switch result {
            case .success(let overview):
                self?.handleSuccess(overview)
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func handleSuccess(_ collectionOverview: Collection.Overview) {
        objectsTotalCount = collectionOverview.count
        sections = []
        var artObjects: [String: [OverviewCollectionViewCellModel]] = [:]
        for artObject in collectionOverview.artObjects {
            let model = OverviewCollectionViewCellModel(
                objectNumber: artObject.objectNumber,
                title: artObject.title,
                imageURL: URL(string: artObject.webImage.url)
            )
            let principalOrFirstMaker = artObject.principalOrFirstMaker
            artObjects[principalOrFirstMaker, default: []].append(model)
        }
        for (key, value) in artObjects.sorted(by: { $0.key < $1.key }) {
            sections.append(OverviewSection(name: "Author: " + key, cells: value))
        }
        state = sections.isEmpty ? .empty : .loaded
    }
    
    func handleError(_ error: Error) {
        // MARK: custom handlers can be added here (e.g. retry button for timedOut, offline message for offline etc)
        if let networkError = error as? NetworkError {
            
        } else if let encodeError = error as? EncodeError {
            
        }
        state = .error(error.localizedDescription)
    }
}
