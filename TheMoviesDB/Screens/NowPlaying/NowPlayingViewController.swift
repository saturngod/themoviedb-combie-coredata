//
//  MainScreenViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import UIKit
import Combine

class NowPlayingViewController: UIViewController {
    
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Movie>
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<NowPlayingViewModel.Input,Never> = .init()
    private let cancelables = Set<AnyCancellable>()
    private let vm = NowPlayingViewModel(useCase: MovieUseCase(networkService: NetworkService()))
    private let router = Router()
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func makeDataSource() -> DataSource {
        
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, video) ->
                UICollectionViewCell? in
                // 2
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "VideoCollectionViewCell",
                    for: indexPath) as? UICollectionViewCell
                
                return cell
            })
        
        return dataSource
    }
    
    func applySnapshot(data: [Movie]) {
        var snapshot = Snapshot()
        snapshot.appendItems(data, toSection: 1)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink {[weak self] event in
                switch event {
                case .loading(let loaded):
                    print("LOADING OR NOT \(loaded)")
                case .newData(let data):
                    self?.applySnapshot(data: data)
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

