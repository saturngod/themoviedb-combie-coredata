//
//  MovieResource.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import Foundation


enum ApiPath {
    case genre
    case nowPlaying (page: Int)
    
    var value: String {
        switch self {
        case .genre : return "/genre/movie/list"
        case .nowPlaying(let page) : return "movie/now_playing?page=\(page)"
        }
    }
}

extension Resource {
    
    static func loadData<T>(path: ApiPath) -> Resource<T> {
        
        let url = ApiConstants.baseUrl.appendingPathComponent(path.value)
        
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            ]
        return Resource<T>(url: url, parameters: parameters)
    }
    
    static func genre() -> Resource<Genre> {
        return loadData(path: .genre)
    }
    
    static func nowPlaying(page: Int) -> Resource<MovieResp> {
        return loadData(path: .nowPlaying(page: 1))
    }
        
}
