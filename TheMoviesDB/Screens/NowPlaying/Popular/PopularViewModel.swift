//
//  PopularViewModel.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 13/10/2022.
//

import Foundation
import Combine

class PopularViewModel: NowPlayingViewModel {
    
    override func loadData() {
        
        if !shouldLoadNext {
            return
        }
        
        self.output.send(.loading(loaded: true))
        
        self.useCase.popularList(page: self.page).sink { [weak self] completion in
            self?.output.send(.loading(loaded: false))
            if case .failure(let error) = completion {
                self?.output.send(.failure(error: error))
            }
        } receiveValue: { [weak self] movieResp in
            
            self?.receiveValue(movieResp: movieResp)
            
        }.store(in: &cancellables)
        
    }

    
}
