//
//  SearchMovieModelType.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 14/10/2022.
//

import UIKit
import Combine


extension SearchMovieViewModel {
    
    // MARK: - ENUM for Input and State
    enum Input {
        case search(value: String)
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
typealias SearchMovieViewModelInput = AnyPublisher<SearchMovieViewModel.Input, Never>

// MARK: - Model Type for transform
protocol SearchMovieViewModelType: AnyObject {
    func transform(input: SearchMovieViewModelInput) -> SearchMovieViewModelOutput
}
