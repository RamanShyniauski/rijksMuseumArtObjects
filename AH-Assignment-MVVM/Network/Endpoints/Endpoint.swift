//
//  Endpoint.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Alamofire
import Foundation

struct Endpoint {

    var baseURL: URL
    var path: String

    static func rijksMuseum(path: String) -> Endpoint {
        Endpoint(baseURL: .rijksMuseum, path: path)
    }
}

extension Endpoint: URLConvertible {

    func asURL() -> URL {
        baseURL.appendingPathComponent(path)
    }
}
