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
    private var data: [Movie] = []
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
       
       
        self.data.append(contentsOf: movieResp.results)
        self.output.send(.newData(data: movieResp.results))
       
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
    
    func shouldLoadNext(row: Int) -> Bool {
        
        return (row == data.count - 3 && shouldLoadNext)
    }
    
    func transform(input: SearchMovieViewModelInput) -> SearchMovieViewModelOutput {
        
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
            .removeDuplicates()
        
        searchInput.sink { [weak self] event in
            switch event {
            case .search(let value):
                self?.searchMovie(query: value,page: 1)
            }
        }.store(in: &cancellables)

        input.list.sink { [weak self] event in
            switch event {
            case .loadNext:
                self?.load()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
