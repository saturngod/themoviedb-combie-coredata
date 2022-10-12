//
//  LoadFileExt.swift
//  TheMoviesDBTests
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import Foundation

extension Decodable {
    static func loadFromFile(testBundle: Bundle, filename: String) -> Self {
        do {
            
            let path = testBundle.path(forResource: filename, ofType: nil)!
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}
