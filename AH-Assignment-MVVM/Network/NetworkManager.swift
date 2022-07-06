//
//  NetworkManager.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Alamofire
import Foundation

protocol NetworkManager {
    func request<Response: Decodable>(_ request: URLRequestConvertible) async throws -> Response
}

final class NetworkManagerImpl: NetworkManager {

    private let session: Session

    init(session: Session) {
        self.session = session
    }
    
    func request<Response: Decodable>(_ request: URLRequestConvertible) async throws -> Response {
        let request = session.request(request).validate()
        let response = await request.serializingDecodable(Response.self).response
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
