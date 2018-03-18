//
//  StubFactory.swift
//  MoviesTests
//
//  Created by Alan Jeferson on 18/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation

@testable import Movies

struct StubFactory {
    
    func genres(_ amount: Int) -> [Genre] {
        return (0..<amount).map { Genre(id: $0, name: "$0") }
    }
    
    func movies(_ amount: Int) -> [Movie] {
        return (0..<amount).map { Movie(id: $0, title: "\($0)", posterPath: "\($0)", backdropPath: "\($0)", overview: "\($0)", adult: false, releaseDateStr: "2018-10-10", genreIds: [Int](), originalTitle: "\($0)") }
    }
    
}
