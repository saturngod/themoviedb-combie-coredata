//
//  FavouriteViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 16/10/2022.
//

import UIKit
import Combine
class FavouriteViewController: UIViewController {
    
    enum TableSection{
        case list
    }
    
    typealias TableDataSource = UITableViewDiffableDataSource<TableSection, Favourite>
    
    typealias TableSnapshot = NSDiffableDataSourceSnapshot<TableSection, Favourite>
    
    private var router = Router()
    
    @IBOutlet weak var tableView: UITableView!
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<FavouriteViewModel.Input,Never> = .init()
    
    private lazy var vm: FavouriteViewModel = FavouriteViewModel(useCase: FavouriteUseCase())
    
    
    private lazy var dataSource = makeDataSource()
    
    func makeDataSource() -> TableDataSource {
        return TableDataSource(tableView: tableView) { tableView, indexPath, movie in
            guard let cell: SearchResultCell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier) as? SearchResultCell else {
                assertionFailure("Fail to deque TableViewcell")
                return UITableViewCell()
            }
            cell.favourite = movie
            
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.appear)
    }
    
    func configureUI() {
        
        tableView.register(UINib(nibName: SearchResultCell.nibName, bundle: .main), forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        
        tableView.delegate = self
        
        
    }
    
    func applyData (data: [Favourite]) {
        var snapShot = TableSnapshot()
        snapShot.appendSections([.list])
        snapShot.appendItems(data)
        self.dataSource.apply(snapShot,animatingDifferences: true)
    }
    
    func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink {[weak self] event in
                switch event {
                case .loadData(let data):
                    self?.applyData(data: data)
                case .failure(let error):
                    print(error)
                }
            }.store(in: &cancellables)
    }
    
    
}



extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            input.send(.deleteAt(index: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, success) in
           
            self?.input.send(.deleteAt(index: indexPath.row))
                success(true)
            }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
