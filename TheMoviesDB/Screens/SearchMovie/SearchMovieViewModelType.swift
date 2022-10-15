//
//  SearchMovieModelType.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 14/10/2022.
//

import UIKit
import Combine


extension SearchMovieViewModel {
    
    enum SearchInput: Equatable {
        case search(value: String)
    }
    enum Input {
        case loadNext
    }
    
    enum State {
        case loading(loaded: Bool)
        case newData(data: [Movie])
        case failure(error: Error)
    }
}


// MARK: - Input Output
typealias SearchMovieViewModelOutput = AnyPublisher<SearchMovieViewModel.State, Never>

struct SearchMovieViewModelInput {
    let list: AnyPublisher<SearchMovieViewModel.Input, Never>
    let search: AnyPublisher<SearchMovieViewModel.SearchInput, Never>
    
}
// MARK: - Model Type for transform
protocol SearchMovieViewModelType: AnyObject {
    func transform(input: SearchMovieViewModelInput) -> SearchMovieViewModelOutput
}
