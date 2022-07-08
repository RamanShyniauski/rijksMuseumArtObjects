//
//  KeyRequestAdapter.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 07/07/2022.
//

import Alamofire
import Foundation

struct KeyRequestAdapter: RequestAdapter {
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Swift.Result<URLRequest, Error>
    ) -> Void) {
        do {
            let parameters = ["key": Bundle.main.apiKey]
            let encodedURLRequest = try URLEncodedFormParameterEncoder.default.encode(parameters, into: urlRequest)
            completion(.success(encodedURLRequest))
        } catch {
            completion(.failure(EncodeError.keyAdoptionFailed))
        }
    }
}
