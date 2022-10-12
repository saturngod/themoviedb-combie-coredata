//
//  Movie.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import Foundation

import Foundation

// MARK: - Genre
class Genre: Codable {
    let genres: [GenreItem]

    init(genres: [GenreItem]) {
        self.genres = genres
    }
}

// MARK: - GenreElement
class GenreItem: Codable {
    let id: Int
    let name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
