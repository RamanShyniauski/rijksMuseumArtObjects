//
//  NetworkManager.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Alamofire
import Foundation

protocol NetworkManager {
    func request<Response: Decodable>(
        _ request: URLRequestConvertible,
        completion: @escaping (Swift.Result<Response, Error>) -> Void
    )
}

final class NetworkManagerImpl: NetworkManager {

    private let session: Session

    init(session: Session) {
        self.session = session
    }
    
    func request<Response: Decodable>(
        _ request: URLRequestConvertible,
        completion: @escaping (Swift.Result<Response, Error>) -> Void
    ) {
        session
            .request(request)
            .validate()
            .responseDecodable(of: Response.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
