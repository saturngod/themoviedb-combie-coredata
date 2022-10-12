//
//  ViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import UIKit
import Combine

class SplashViewController: UIViewController {

    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<SplashViewModel.Input,Never> = .init()
    private let cancelables = Set<AnyCancellable>()
    private let vm = SplashViewModel(useCase: MovieUseCase(networkService: NetworkService()))
    
    private let router = Router()
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink {[weak self] event in
                switch event {
                case .loading(let loaded):
                    if loaded {
                        self?.loadingActivity.startAnimating()
                    }
                    else {
                        self?.loadingActivity.stopAnimating()
                    }
                    
                case .success(let genre):
                    GlobalService.shared.genres = genre
                    self?.router.route(from: self, to: .MainScreen, present: true,animated: false)
                case .failure(let error):
                    self?.errorLabel.text = error.localizedDescription
                    
                }
                
            }.store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        input.send(.appear)
    }
    
    


}

