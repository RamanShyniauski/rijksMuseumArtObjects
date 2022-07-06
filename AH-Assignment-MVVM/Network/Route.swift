//
//  Route.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Alamofire
import Foundation

struct Route: URLRequestConvertible {

    private var method: HTTPMethod
    private var endpoint: Endpoint
    private var parameters: Alamofire.Parameters?
    private var headers: HTTPHeaders?

    init(
        _ method: HTTPMethod,
        _ endpoint: Endpoint,
        with parameters: Alamofire.Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) {
        self.method = method
        self.endpoint = endpoint
        self.parameters = parameters
        self.headers = headers
    }

    private var encoding: ParameterEncoding {
        switch method {
        case .get, .delete, .head:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

    func asURLRequest() throws -> URLRequest {
        let request = try URLRequest(
            url: endpoint,
            method: method,
            headers: headers
        )
        return try encoding.encode(request, with: parameters)
    }
}
