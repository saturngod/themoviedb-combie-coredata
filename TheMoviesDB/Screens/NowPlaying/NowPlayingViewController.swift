//
//  MainScreenViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import UIKit
import Combine

class NowPlayingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<NowPlayingViewModel.Input,Never> = .init()
    private let cancelables = Set<AnyCancellable>()
    private let vm = NowPlayingViewModel(useCase: MovieUseCase(networkService: NetworkService()))
    
    private let router = Router()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink {[weak self] event in
                switch event {
                case .loading(let loaded):
                    print("LOADING OR NOT \(loaded)")
                case .newData(let data):
                    print("update snapshot")
                case .failure(let error):
                    print("show error")
                    
                }
            }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.appear)
        
    }
}

