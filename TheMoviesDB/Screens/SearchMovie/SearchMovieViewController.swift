//
//  SearchMovieViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 14/10/2022.
//

import UIKit
import Combine
class SearchMovieViewController: UIViewController {
    
    
    enum TableSection{
        case list
    }

    typealias TableDataSource = UITableViewDiffableDataSource<TableSection, Movie>
    
    typealias TableSnapshot = NSDiffableDataSourceSnapshot<TableSection, Movie>
    
    
    
    @IBOutlet weak var tableView: UITableView!
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<SearchMovieViewModel.Input,Never> = .init()
    private lazy var vm: SearchMovieViewModel = SearchMovieViewModel(useCase: MovieUseCase(networkService: NetworkService()))
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    func configureUI() {
        navigationItem.searchController = self.searchController
        searchController.isActive = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
        
        tableView.register(UINib(nibName: SearchResultCell.nibName, bundle: .main), forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        
        
        
    }
    
    
    func makeDataSource() -> TableDataSource {
        return TableDataSource(tableView: tableView) { tableView, indexPath, movie in
            guard let cell: SearchResultCell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier) as? SearchResultCell else {
                assertionFailure("Fail to deque TableViewcell")
                return UITableViewCell()
            }
            cell.video = movie
            
            return cell
        }
    }
    
    func updateData(newData: [Movie]) {
        var snapShot = TableSnapshot()
        snapShot.appendSections([.list])
        snapShot.appendItems(vm.getData())
        self.dataSource.apply(snapShot,animatingDifferences: true)
    }
    
    func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink {[weak self] event in
                switch event {
                case .loading(loaded: let loaded):
                    print("LOADING \(loaded)")
                case .newData(data: let data):
                    self?.updateData(newData: data)
                case .failure(error: let error):
                    print("FAIL \(error.localizedDescription)")
                }
            }.store(in: &cancellables)
    }
    

}


extension SearchMovieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        input.send(.search(value: searchText))
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //search.send("")
    }
}
