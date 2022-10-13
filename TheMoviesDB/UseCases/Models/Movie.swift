//
//  Movie.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import Foundation


// MARK: - MovieResp
class MovieResp: Codable {
    let dates: DateResp?
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(dates: DateResp, page: Int, results: [Movie], totalPages: Int, totalResults: Int) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Dates
class DateResp: Codable {
    let maximum, minimum: String

    init(maximum: String, minimum: String) {
        self.maximum = maximum
        self.minimum = minimum
    }
}

// MARK: - Result
class Movie: Codable, Hashable{
    
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double
    let posterPath, releaseDate, title: String?
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    var dateInfo: String? {
        let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "yyyy-MM-dd"
        if let rd = releaseDate, let date = dateFormatter.date(from:rd) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
        
    }
    
    var genreText: String? {
        let genreName: [String] = genreIDS.map {GlobalService.shared.genres?.nameFrom(id: $0) ?? ""}
        return genreName.joined(separator: ",")
    }
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(adult: Bool, backdropPath: String, genreIDS: [Int], id: Int, originalLanguage: String, originalTitle: String, overview: String, popularity: Double, posterPath: String, releaseDate: String, title: String, video: Bool, voteAverage: Double, voteCount: Int) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
      lhs.id == rhs.id
    }
}
