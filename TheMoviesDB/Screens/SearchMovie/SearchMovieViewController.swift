//
//  SearchMovieViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 14/10/2022.
//

import UIKit

class SearchMovieViewController: UIViewController {
    
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = self.searchController
        searchController.isActive = true
    }
}


extension SearchMovieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //search.send(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //search.send("")
    }
}
