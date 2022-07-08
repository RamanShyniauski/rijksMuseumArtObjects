//
//  OverviewCoordinator.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import UIKit

protocol OverviewCoordinator {
    func start()
    func showDetails(for objectNumber: String)
    func back()
}

final class OverviewCoordinatorImpl: OverviewCoordinator {
    
    private unowned let navigationController: UINavigationController
    private let dependencyContainer: DependencyContainer
    
    init(
        navigationController: UINavigationController,
        dependencyContainer: DependencyContainer
    ) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        let viewModel = OverviewViewModelImpl(
            coordinator: self,
            networkManager: dependencyContainer.networkManager
        )
        let viewController = OverviewViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showDetails(for objectNumber: String) {
        let viewModel = DetailsViewModelImpl(
            objectNumber: objectNumber,
            coordinator: self,
            networkManager: dependencyContainer.networkManager
        )
        let viewController = DetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
