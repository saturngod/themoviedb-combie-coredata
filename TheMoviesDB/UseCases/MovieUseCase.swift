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
    func nowPlayingList(page: Int) -> AnyPublisher<MovieResp,Error>
    func popularList(page: Int) -> AnyPublisher<MovieResp,Error>
    func topRatedList(page: Int) -> AnyPublisher<MovieResp,Error> 
}

final class MovieUseCase: MovieUseCaseType {
    
    
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func genreList() -> AnyPublisher<Genre, Error> {
        return networkService.load(Resource<Genre>.genre())
            .catch { error -> AnyPublisher<Genre,Error> in
                return Fail(error: error).eraseToAnyPublisher()
                
            }
            .eraseToAnyPublisher()
    }
    
    func nowPlayingList(page: Int) -> AnyPublisher<MovieResp,Error> {
        
        return networkService.load(Resource<MovieResp>.nowPlaying(page: page))
            .catch { error -> AnyPublisher<MovieResp,Error> in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func popularList(page: Int) -> AnyPublisher<MovieResp,Error> {
        
        return networkService.load(Resource<MovieResp>.popular(page: page))
            .catch { error -> AnyPublisher<MovieResp,Error> in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func topRatedList(page: Int) -> AnyPublisher<MovieResp,Error> {
        
        return networkService.load(Resource<MovieResp>.topRated(page: page))
            .catch { error -> AnyPublisher<MovieResp,Error> in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    
    
    
}
