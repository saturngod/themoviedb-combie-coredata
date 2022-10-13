//
//  MainScreenViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import UIKit
import Combine

class NowPlayingViewController: UIViewController {
    
    enum Section{
        case list
    }
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<NowPlayingViewModel.Input,Never> = .init()
    private let cancelables = Set<AnyCancellable>()
    private lazy var vm: NowPlayingViewModel = setupModel()
    private let router = Router()
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        bind()
    }
    
    func setupModel() -> NowPlayingViewModel {
        return NowPlayingViewModel(useCase: MovieUseCase(networkService: NetworkService()))
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: MoviePosterCollectionCell.nibName, bundle: .main), forCellWithReuseIdentifier: MoviePosterCollectionCell.reuseIdentifier)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            
            let itemCount = 3
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12)
            // Group
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(3/5))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: itemCount)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        })
        
        dataSource = makeDataSource()
    }
    
    func makeDataSource() -> DataSource {
        
        let dataSource = DataSource(
            collectionView: self.collectionView,
            cellProvider: {  [weak self] (collectionView, indexPath, video) ->
                UICollectionViewCell? in
                // 2
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MoviePosterCollectionCell.reuseIdentifier,
                    for: indexPath) as? MoviePosterCollectionCell else {
                    return UICollectionViewCell()
                }
                
                cell.video = video
                
                if let vm = self?.vm {
                    if vm.shouldLoadNext(row: indexPath.row) {
                        self?.input.send(.loadNext)
                    }
                }
                
                return cell
            })
        
     
        
        return dataSource
    }
    
    func applySnapshot(data: [Movie]) {
        
        var snapshot = Snapshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(self.vm.getData())
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
                    print("show error \(error.localizedDescription)")
                }
            }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.appear)
        
    }
}

