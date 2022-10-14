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
    
    init(useCase: MovieUseCaseType) {
        self.useCase = useCase
    }
    
    
    func getData() -> [Movie] {
        return self.data
    }
    
    
    func transform(input: SearchMovieViewModelInput) -> SearchMovieViewModelOutput {
        input.sink { [weak self] event in
            switch event {
            case .search(let value):
                print(value)
            case .loadNext:
                print("LOAD NEXT")
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
