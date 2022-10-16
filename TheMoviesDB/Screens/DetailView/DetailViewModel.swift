//
//  DetailViewModel.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 15/10/2022.
//

import UIKit
import Combine
import CoreData

class DetailViewModel: DefaultViewModelType & DetailViewModelType {
    
    var cancellables = Set<AnyCancellable>()
    let output: PassthroughSubject<State, Never> = .init()
    
    private var favUseCase = FavouriteUseCase()
    
    private var currentFav = false
    private var fav: Favourite?
    
    func transform(input: DetailViewModelInput) -> DetailViewModelOutput {
        
        input.sink { [weak self] event in
            switch event {
            case  .toggleFavourite:
                self?.toggleFav()
            case .appear:
                self?.checkFav()
            }
            
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private var movie: Movie?
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func getMovie()-> Movie? {
        return self.movie
    }
    
    private func updateFav(isFav: Bool) {
        
        if(isFav) {
            //make favourite
            if let mov = self.movie {
                favUseCase.saveFavourite(movie: mov)
                currentFav = true
            }
        }
        else {
            //delete it
            if let myfav = fav {
                favUseCase.deleteFavourite(movie: myfav)
                currentFav = false
            }
        }
        output.send(.changeFav(data: currentFav))
    }
    
    func toggleFav() {

        updateFav(isFav: !currentFav)
    }
    
    func checkFav() {
        
        guard let mov = self.movie else {
            currentFav = false
            output.send(.changeFav(data: currentFav))
            return
        }
        
        if let data = favUseCase.getBy(id: mov.id) {
            fav = data
            currentFav = true
            output.send(.changeFav(data: currentFav))
        }
        else {
            currentFav = false
            output.send(.changeFav(data: currentFav))
        }
    }
    
}
