//
//  SearchMovieViewModel.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 14/10/2022.
//

import UIKit
import Combine

class SearchMovieViewModel: SearchMovieViewModelType {
    
    var useCase: MovieUseCaseType
    var cancellables = Set<AnyCancellable>()
    let output: PassthroughSubject<State, Never> = .init()
    var page = 1
    var data: [Movie] = []
    var shouldLoadNext = true
    var query = ""
    
    init(useCase: MovieUseCaseType) {
        self.useCase = useCase
    }
    
    
    func getData() -> [Movie] {
        return self.data
    }
    
    func receiveValue(movieResp: MovieResp) {
        
        if(movieResp.totalPages == self.page) {
            self.shouldLoadNext = false
        }
       
        self.page = self.page + 1
       
        if(movieResp.results.count > 0) {
            self.data.append(contentsOf: movieResp.results)
            self.output.send(.newData(data: movieResp.results))
        }
    }
    
    func searchMovie(query: String,page: Int) {
        
        self.output.send(.loading(loaded: true))
        
        self.shouldLoadNext = true
        self.data.removeAll()
        self.page = page
        self.query = query
        self.load()
    }
    
    func load() {
        self.useCase.search(query: self.query, page: self.page).sink { [weak self] completion in
            self?.output.send(.loading(loaded: false))
            if case .failure(let error) = completion {
                self?.output.send(.failure(error: error))
            }
        } receiveValue: { [weak self] movieResp in
            
            self?.receiveValue(movieResp: movieResp)
            
        }.store(in: &cancellables)
    }
    
    
    
    func transform(input: SearchMovieViewModelInput) -> SearchMovieViewModelOutput {
        input.sink { [weak self] event in
            switch event {
            case .search(let value):
                self?.searchMovie(query: value,page: 1)
            case .loadNext:
                self?.load()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}