//
//  PopularViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 13/10/2022.
//

import UIKit
import Combine

class TopRateViewController: NowPlayingViewController {

    override func setupModel() -> NowPlayingViewModel {
        return TopRateViewModel(useCase: MovieUseCase(networkService: NetworkService()))
    }
}
