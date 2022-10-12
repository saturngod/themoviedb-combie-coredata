//
//  NowPlayingViewModelType.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import Foundation
import Combine

extension NowPlayingViewModel {
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


typealias NowPlayingViewModelOutput = AnyPublisher<NowPlayingViewModel.State, Never>
typealias NowPlayingViewModelInput = AnyPublisher<NowPlayingViewModel.Input, Never>

protocol NowPlayingViewModelType: AnyObject {
    func transform(input: NowPlayingViewModelInput) -> NowPlayingViewModelOutput
}
