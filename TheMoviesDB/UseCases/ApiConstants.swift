//
//  ApiConstants.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import Foundation

struct ApiConstants {
    static let apiKey = "181af7fcab50e40fabe2d10cc8b90e37"
    static let baseUrl = URL(string: "https://api.themoviedb.org/3")!
    static let originalImageUrl = URL(string: "https://image.tmdb.org/t/p/original")!
    static let smallImageUrl = URL(string: "https://image.tmdb.org/t/p/w300")!
    static let backdropImageUrl = URL(string: "https://image.tmdb.org/t/p/w700")!
}
