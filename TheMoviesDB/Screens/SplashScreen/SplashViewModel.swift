//
//  SplashViewModel.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import UIKit
import Combine

class SplashViewModel: SplashViewModelType {
    
    private var useCase: MovieUseCaseType
    private var cancellables = Set<AnyCancellable>()
    private let output: PassthroughSubject<SplashViewState, Never> = .init()
    
    init(useCase: MovieUseCaseType) {
        self.useCase = useCase
    }
    
    private func loadData() {
        self.output.send(.loading)
        self.useCase.genreList().sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.output.send(.failure(error: error))
            }
        } receiveValue: { [weak self] genre in
            self?.output.send(.success(genre: genre))
        }.store(in: &cancellables)
    }
    func transform(input: SplashViewModelInput) -> SplashViewModelOutput {
        
        input.sink { [weak self] event in
            switch event {
            case .appear :
                self?.loadData()
            }
            
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
          
    }
    
    
    
}

