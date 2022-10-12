//
//  NowPlayingViewModel.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import Foundation
import Combine

class NowPlayingViewModel: NowPlayingViewModelType {

    private var useCase: MovieUseCaseType
    private var cancellables = Set<AnyCancellable>()
    private let output: PassthroughSubject<State, Never> = .init()
    private var page = 1
    private var data: [Movie] = []
    private var shouldLoadNext = true
    
    init(useCase: MovieUseCaseType) {
        self.useCase = useCase
    }
    
    
    private func loadData() {
        
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
            
            if(movieResp.totalPages == self?.page) {
                self?.shouldLoadNext = false
            }
            else if let pg = self?.page {
                self?.page = pg + 1
            }
            
            if(movieResp.results.count > 0) {
                self?.data.append(contentsOf: movieResp.results)
                self?.output.send(.newData(data: movieResp.results))
            }
            
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
