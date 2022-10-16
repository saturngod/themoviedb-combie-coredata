//
//  DetailViewModelType.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 16/10/2022.
//

import Foundation
import Combine
extension DetailViewModel {
    
    // MARK: - ENUM for Input and State
    enum Input {
        case toggleFavourite
        case appear
    }
    
    enum State {
        case changeFav(data: Bool)
    }
}


// MARK: - Input Output
typealias DetailViewModelOutput = AnyPublisher<DetailViewModel.State, Never>
typealias DetailViewModelInput = AnyPublisher<DetailViewModel.Input, Never>

// MARK: - Model Type for transform
protocol DetailViewModelType: AnyObject {
    
    func transform(input: DetailViewModelInput) -> DetailViewModelOutput
}



