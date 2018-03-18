//
//  MovieDetailViewModelTests.swift
//  MoviesTests
//
//  Created by Alan Jeferson on 18/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Movies

class MovieDetailViewModelTests: QuickSpec {
    
    override func spec() {
        
        let factory = StubFactory()
        var movie: Movie!
        var genres: [Genre]!
        var imageService: ImageServiceMock!
        var viewModel: MovieDetailViewModel!
        let scheduler = Schedulers.current
        
        beforeEach {
            movie = Movie(id: 1, title: "Some movie", posterPath: "some", backdropPath: "some", overview: "overview", adult: false, releaseDateStr: "2017-10-10", genreIds: [1, 2], originalTitle: "Some movie original")
            genres = [
                Genre(id: 1, name: "Action"),
                Genre(id: 2, name: "Adventure"),
                Genre(id: 3, name: "Commedy")
            ]
            imageService = ImageServiceMock()
            viewModel = MovieDetailViewModel(movie: movie, genres: genres, imageService: imageService, ioScheduler: scheduler, uiScheduler: scheduler)
        }
        
        describe("movie detail view model") {
            
            it("presentation") {
                expect(viewModel.title).to(equal(movie.title))
                expect(viewModel.overview).to(equal(movie.overview))
                let date = DateFormatter.default.date(from: viewModel.releaseDateStr!)
                expect(date).notTo(beNil())
            }
            
            context("fetch poster") {
                
                it("nil") {
                    movie.posterPath = nil
                    viewModel = MovieDetailViewModel(movie: movie, genres: genres, imageService: imageService, ioScheduler: scheduler, uiScheduler: scheduler)
                    viewModel.fetchPoster()
                    expect(imageService.fetchImageCalled) == false
                }
                
                it("present") {
                    expect(imageService.fetchImageCalled) == false
                    viewModel.fetchPoster()
                    expect(imageService.fetchImageCalled) == true
                    imageService.fetchSuccess(Data())
                }
                
            }
            
            context("fetch backdrop") {
                
                it("nil") {
                    movie.backdropPath = nil
                    viewModel = MovieDetailViewModel(movie: movie, genres: genres, imageService: imageService, ioScheduler: scheduler, uiScheduler: scheduler)
                    viewModel.fetchBackdrop()
                    expect(imageService.fetchImageCalled) == false
                }
                
                it("present") {
                    expect(imageService.fetchImageCalled) == false
                    viewModel.fetchBackdrop()
                    expect(imageService.fetchImageCalled) == true
                    imageService.fetchSuccess(Data())
                }
                
            }
            
        }
        
    }
    
}

