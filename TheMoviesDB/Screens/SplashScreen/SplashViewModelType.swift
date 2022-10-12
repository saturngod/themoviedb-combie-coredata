//
//  SplashViewModelType.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import UIKit
import Combine

enum SplashViewInput {
    case appear
}

enum SplashViewState {
    case loading
    case success(genre: Genre)
    case failure(error: Error)
}


typealias SplashViewModelOutput = AnyPublisher<SplashViewState, Never>
typealias SplashViewModelInput = AnyPublisher<SplashViewInput, Never>

protocol SplashViewModelType: AnyObject {
    func transform(input: SplashViewModelInput) -> SplashViewModelOutput
}
