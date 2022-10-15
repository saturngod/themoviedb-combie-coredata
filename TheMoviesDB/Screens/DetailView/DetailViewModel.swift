//
//  DetailViewModel.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 15/10/2022.
//

import Foundation

class DetailViewModel: DefaultViewModelType {
    private var movie: Movie?
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func getMovie()-> Movie? {
        return self.movie
    }
    
}
