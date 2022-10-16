//
//  FavouriteViewModel.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 16/10/2022.
//

import Foundation
import Combine

class FavouriteViewModel: FavouriteViewModelType {
    
    var cancellables = Set<AnyCancellable>()
    let output: PassthroughSubject<State, Never> = .init()
    private var data: [Favourite] = []
    private var favUseCase: FavouriteUseCaseType
    
    
    init(useCase: FavouriteUseCaseType) {
        self.favUseCase = useCase
    }
    
    private func loadAll() {
        data = favUseCase.getAllFavourites()
        output.send(.loadData(data: data))
    }
    
    private func delete(fav: Favourite) {
        if let index = data.firstIndex(of: fav) {
            data.remove(at: index)
            favUseCase.deleteFavourite(movie: fav)
            output.send(.loadData(data: data))
        }
    
    }
    
    private func deleteAtIndex(index: Int) {
        if data.count > index {
            let fav = data[index]
            data.remove(at: index)
            favUseCase.deleteFavourite(movie: fav)
            output.send(.loadData(data: data))
        }
        
    }
    
    func transform(input: FavouriteViewModelInput) -> FavouriteViewModelOutput {
        
        input.sink { [weak self] event in
            switch event {
            case  .appear:
                self?.loadAll()
            case .deleteAt(let index):
                self?.deleteAtIndex(index: index)
            case .delete(let fav):
                self?.delete(fav: fav)
            }
            
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    
}
