//
//  OverviewViewModel.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Foundation

protocol OverviewViewModel {
    
}

class OverviewViewModelImpl: OverviewViewModel {
    
    private let coordinator: OverviewCoordinator
    
    init(coordinator: OverviewCoordinator) {
        self.coordinator = coordinator
    }
}
