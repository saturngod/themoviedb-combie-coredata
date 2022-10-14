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
    case popular (page: Int)
    case topRated (page: Int)
    case upComing (page: Int)
    case search (query: String,page: Int)
    
    var value: String {
        switch self {
        case .genre : return "/genre/movie/list"
        case .nowPlaying(let page) : return "movie/now_playing?page=\(page)"
        case .popular(let page) : return "movie/popular?page=\(page)"
        case .topRated(let page) : return "movie/top_rated?page=\(page)"
        case .upComing(let page) : return "movie/upcoming?page=\(page)"
        case .search(let query,let page) : return "search/movie?query=\(query)&page=\(page)"
        }
    }
}

extension Resource {
    
    static func loadData<T>(path: ApiPath) -> Resource<T> {
        
        var url: URL!
        
        if let urlToLoad = ApiConstants.baseUrl.appendingPathComponent(path.value).absoluteString.removingPercentEncoding {
             url = URL(string: urlToLoad)
        }
        else {
            url = ApiConstants.baseUrl.appendingPathComponent(path.value)
        }
        
        
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            ]
        return Resource<T>(url: url, parameters: parameters)
    }
    
    static func genre() -> Resource<Genre> {
        return loadData(path: .genre)
    }
    
    static func nowPlaying(page: Int) -> Resource<MovieResp> {
        return loadData(path: .nowPlaying(page: page))
    }
    
    static func popular(page: Int) -> Resource<MovieResp> {
        return loadData(path: .popular(page: page))
    }
    
    static func topRated(page: Int) -> Resource<MovieResp> {
        return loadData(path: .topRated(page: page))
    }
    
    static func upComing(page: Int) -> Resource<MovieResp> {
        return loadData(path: .upComing(page: page))
    }
    
    static func search(query: String,page: Int) -> Resource<MovieResp> {
        return loadData(path: .search(query: query,page: page))
    }
        
}
