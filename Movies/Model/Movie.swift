//
//  Movie.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    var id: Int
    var title: String
    var posterPath: String?
    var backdropPath: String?
    var overview: String
    var adult: Bool
    var releaseDateStr: String
    var genreIds: [Int]
    var originalTitle: String

    // JSON representation of a Movie
    // Converting snake_case to CamelCase
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case adult
        case releaseDateStr = "release_date"
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
    }
    
    static func from(data: Data) -> [Movie]? {
        let decoder = JSONDecoder()
        do {
            let results = try decoder.decode(MovieResults.self, from: data)
            guard let movies = results.results else { return nil }
            return movies
        } catch {
            return nil
        }
    }
    
}
