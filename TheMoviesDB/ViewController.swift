//
//  ViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import UIKit
import Combine

class SplashViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.testLoading()
    }
    
    func testLoading() {
        let useCase = MovieUseCase(networkService: NetworkService())
        useCase.genreList().sink { completion in
            
        }
    receiveValue: { genre in
        print(genre.genres[0].name)
        }
        .store(in: &cancellables)
            
        
    }


}

