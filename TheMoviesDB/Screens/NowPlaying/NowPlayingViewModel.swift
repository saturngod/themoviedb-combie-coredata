//
//  NowPlayingViewModel.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import Foundation
import Combine

class NowPlayingViewModel: NowPlayingViewModelType {

    var useCase: MovieUseCaseType
    var cancellables = Set<AnyCancellable>()
    let output: PassthroughSubject<State, Never> = .init()
    var page = 1
    var data: [Movie] = []
    var shouldLoadNext = true
    
    
    init(useCase: MovieUseCaseType) {
        self.useCase = useCase
    }
    
    
    func getData() -> [Movie] {
        return self.data
    }
    
    func shouldLoadNext(row: Int) -> Bool {
        
        return (row == data.count - 3 && shouldLoadNext)
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
    
    func loadData() {
        
        if !shouldLoadNext {
            return
        }
        
        self.output.send(.loading(loaded: true))
        
        self.useCase.nowPlayingList(page: self.page).sink { [weak self] completion in
            self?.output.send(.loading(loaded: false))
            if case .failure(let error) = completion {
                self?.output.send(.failure(error: error))
            }
        } receiveValue: { [weak self] movieResp in
            
            self?.receiveValue(movieResp: movieResp)
            
        }.store(in: &cancellables)
        
    }
    
    func transform(input: NowPlayingViewModelInput) -> NowPlayingViewModelOutput {
        
        input.sink { [weak self] event in
            switch event {
            case .appear , .loadNext :
                self?.loadData()
            }
            
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
}
