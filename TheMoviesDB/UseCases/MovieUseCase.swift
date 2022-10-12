//
//  MovieUseCase.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import Foundation
import Combine

protocol MovieUseCaseType {
    func genreList() -> AnyPublisher<Genre,Error>
}

final class MovieUseCase: MovieUseCaseType {
    
    
    private let networkService: NetworkServiceType
    //private let imageLoaderService: ImageLoaderServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
//        self.imageLoaderService = imageLoaderService
    }
    
    func genreList() -> AnyPublisher<Genre, Error> {
        return networkService.load(Resource<Genre>.genre())
            .catch { error -> AnyPublisher<Genre,Error> in
                return Fail(error: error).eraseToAnyPublisher()
                
            }
            .eraseToAnyPublisher()
    }
    
}
