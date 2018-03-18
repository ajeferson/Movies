//
//  SearchResultsCellViewModel.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation

class SearchResultsCellViewModel {
    
    var title: String
    var releaseDateStr: String?
    
    init(movie: Movie) {
        title = movie.title
        if let date = movie.releaseDate {
            releaseDateStr = DateFormatter.default.string(from: date)
        }
    }
    
}
