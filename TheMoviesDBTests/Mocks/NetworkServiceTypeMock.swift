//
//  NetworkServiceTypeMock.swift
//  TheMoviesDBTests
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import Foundation
import Combine
@testable import TheMoviesDB

final class NetworkServiceTypeMock: NetworkServiceType {
    var responses = [String:Any]()
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        print(resource.url.path)
        if let response = responses[resource.url.path] as? T {
            return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else if let error = responses[resource.url.path] as? NetworkError {
            return Fail(error:error).eraseToAnyPublisher()
        } else {
            return Fail(error:NetworkError.invalidRequest).eraseToAnyPublisher()
        }
    }
}
