//
//  NetworkError.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Alamofire
import Foundation

enum NetworkError: Error {

    struct Response: Equatable {
        var statusCode: Int
        var data: Data?
    }

    case clientError(Response)
    case serverError(Response)
    case unauthorized(Data?)
    case forbidden(Data?)
    case timedOut
    case notConnectedToInternet
    case cannotConnectToHost

    init?(_ error: Error, responseData: Data? = nil) {
        switch error {
        case AFError.responseValidationFailed(.unacceptableStatusCode(let statusCode)) where statusCode == 401:
            self = .unauthorized(responseData)

        case AFError.responseValidationFailed(.unacceptableStatusCode(let statusCode)) where statusCode == 403:
            self = .forbidden(responseData)

        case AFError.responseValidationFailed(.unacceptableStatusCode(let statusCode)) where (400...499).contains(statusCode):
            self = .clientError(
                Response(
                    statusCode: statusCode,
                    data: responseData
                )
            )

        case AFError.responseValidationFailed(.unacceptableStatusCode(let statusCode)) where (500...599).contains(statusCode):
            self = .serverError(
                Response(
                    statusCode: statusCode,
                    data: responseData
                )
            )

        case AFError.requestAdaptationFailed(let networkError as NetworkError),
             AFError.requestRetryFailed(let networkError as NetworkError, _),
             AFError.requestRetryFailed(_, let networkError as NetworkError):
            self = networkError

        case AFError.sessionTaskFailed(let error as NSError) where error.code == NSURLErrorTimedOut:
            self = .timedOut

        case AFError.sessionTaskFailed(let error as NSError) where error.code == NSURLErrorNotConnectedToInternet:
            self = .notConnectedToInternet

        case AFError.sessionTaskFailed(let error as NSError) where error.code == NSURLErrorCannotConnectToHost:
            self = .cannotConnectToHost

        default:
            return nil
        }
    }
}
