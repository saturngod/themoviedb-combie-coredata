//
//  MovieResource.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import Foundation

extension Resource {
    static func genre() -> Resource<Genre> {
        let url = ApiConstants.baseUrl.appendingPathComponent("/genre/movie/list")
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            ]
        return Resource<Genre>(url: url, parameters: parameters)
    }
}
