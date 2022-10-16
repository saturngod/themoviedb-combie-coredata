//
//  FavouriteViewModelType.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 16/10/2022.
//

import Foundation
import Combine
extension FavouriteViewModel {
    
    // MARK: - ENUM for Input and State
    enum Input {
        case appear
        case delete(data: Favourite)
        case deleteAt(index: Int)
    }
    
    enum State {
        case loadData(data: [Favourite])
        case failure(error: Error)
    }
}


// MARK: - Input Output
typealias FavouriteViewModelOutput = AnyPublisher<FavouriteViewModel.State, Never>
typealias FavouriteViewModelInput = AnyPublisher<FavouriteViewModel.Input, Never>

// MARK: - Model Type for transform
protocol FavouriteViewModelType: AnyObject {
    func transform(input: FavouriteViewModelInput) -> FavouriteViewModelOutput
}

