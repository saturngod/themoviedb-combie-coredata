//
//  NowPlayingViewModelType.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import UIKit
import Combine


extension NowPlayingViewModel {
    
   
    
    // MARK: - ENUM for Input and State
    enum Input {
        case appear
        case loadNext
    }
    
    enum State {
        case loading(loaded: Bool)
        case newData(data: [Movie])
        case failure(error: Error)
    }
}


// MARK: - Input Output
typealias NowPlayingViewModelOutput = AnyPublisher<NowPlayingViewModel.State, Never>
typealias NowPlayingViewModelInput = AnyPublisher<NowPlayingViewModel.Input, Never>

// MARK: - Model Type for transform
protocol NowPlayingViewModelType: AnyObject {
    func transform(input: NowPlayingViewModelInput) -> NowPlayingViewModelOutput
}
