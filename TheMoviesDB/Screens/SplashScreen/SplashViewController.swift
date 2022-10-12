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
    private let input: PassthroughSubject<SplashViewInput,Never> = .init()
    private let cancelables = Set<AnyCancellable>()
    private let vm = SplashViewModel(useCase: MovieUseCase(networkService: NetworkService()))
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink {[weak self] event in
               
            }
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

