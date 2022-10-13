//
//  Resource.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import Foundation

struct Resource<T: Decodable> {
    let url: URL
    let parameters: [String: CustomStringConvertible]
    var request: URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        let newParameters: [URLQueryItem] = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        
        if let _ = components.queryItems {
            components.queryItems?.append(contentsOf: newParameters)
        }
        else {
            components.queryItems = newParameters
        }
        
        guard let url = components.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }

    init(url: URL, parameters: [String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}
