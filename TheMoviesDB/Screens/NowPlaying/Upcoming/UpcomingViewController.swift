//
//  PopularViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 13/10/2022.
//

import UIKit
import Combine

class UpcomingViewController: NowPlayingViewController {

    override func setupModel() -> NowPlayingViewModel {
        return UpcomingViewModel(useCase: MovieUseCase(networkService: NetworkService()))
    }
}
