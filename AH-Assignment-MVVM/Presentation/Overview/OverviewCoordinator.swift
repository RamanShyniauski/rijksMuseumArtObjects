//
//  OverviewCoordinator.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import UIKit

protocol OverviewCoordinator {
    func start()
}

final class OverviewCoordinatorImpl: OverviewCoordinator {
    
    private unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = OverviewViewModelImpl(coordinator: self)
        let viewController = OverviewViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
