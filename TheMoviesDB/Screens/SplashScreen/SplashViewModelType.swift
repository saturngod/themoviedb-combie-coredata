//
//  SplashViewModelType.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import UIKit
import Combine

extension SplashViewModel {
    enum Input {
        case appear
    }
    
    enum State {
        case loading(loaded: Bool)
        case success(genre: Genre)
        case failure(error: Error)
    }
}


typealias SplashViewModelOutput = AnyPublisher<SplashViewModel.State, Never>
typealias SplashViewModelInput = AnyPublisher<SplashViewModel.Input, Never>

protocol SplashViewModelType: AnyObject {
    func transform(input: SplashViewModelInput) -> SplashViewModelOutput
}
