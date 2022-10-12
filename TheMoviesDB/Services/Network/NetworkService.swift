//
//  NetworkService.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import Foundation
import Combine

final class NetworkService: NetworkServiceType {
    private let session: URLSession

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.session = session
    }

    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        guard let request = resource.request else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: request)
            .mapError { _ in NetworkError.invalidRequest }
            //.print()
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                }

                guard 200..<300 ~= response.statusCode else {
                    return Fail(error: NetworkError.dataLoadingError(statusCode: response.statusCode, data: data)).eraseToAnyPublisher()
                }
                return Just(data).setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

}
