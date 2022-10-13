//
//  PopularViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 13/10/2022.
//

import UIKit
import Combine

class PopularViewController: NowPlayingViewController {
    var vm = PopularViewModel(useCase: MovieUseCase(networkService: NetworkService()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HELO")
    }
    
    override func setupModel() -> NowPlayingViewModel {
        return PopularViewModel(useCase: MovieUseCase(networkService: NetworkService()))
    }
}
