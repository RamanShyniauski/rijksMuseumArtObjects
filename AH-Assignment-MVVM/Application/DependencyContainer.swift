//
//  DependencyContainer.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Alamofire
import Foundation

final class DependencyContainer {
    
    private lazy var networkSession = Session(
        interceptor: Interceptor(adapters: [KeyRequestAdapter()])
    )
    
    lazy var networkManager: NetworkManager = NetworkManagerImpl(
        session: networkSession
    )
}
