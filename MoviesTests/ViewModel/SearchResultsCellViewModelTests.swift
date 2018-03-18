//
//  SearchResultsCellViewModelTests.swift
//  MoviesTests
//
//  Created by Alan Jeferson on 18/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Movies

class SearchResultsCellViewModelTests: QuickSpec {
    
    override func spec() {
        
        it("presentation") {
            let movie = Movie(id: 1, title: "Some", posterPath: "some", backdropPath: "some", overview: "some", adult: false, releaseDateStr: "2017-10-10", genreIds: [Int](), originalTitle: "Original")
            let viewModel = SearchResultsCellViewModel(movie: movie)
            expect(viewModel.title).to(equal(movie.title))
            let date = DateFormatter.default.date(from: viewModel.releaseDateStr!)
            expect(date).notTo(beNil())
        }
        
    }
    
}
