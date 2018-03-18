//
//  MovieListViewModelTests.swift
//  MoviesTests
//
//  Created by Alan Jeferson on 18/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift
import Quick
import Nimble

@testable import Movies

class MovieListViewModelTests: QuickSpec {
    

    override func spec() {
        
        let factory = StubFactory()
        var movieService: MovieServiceMock!
        var genreService: GenreServiceMock!
        let scheduler = Schedulers.current
        var viewModel: MovieListViewModel!
        
        beforeEach {
            movieService = MovieServiceMock()
            genreService = GenreServiceMock()
            viewModel = MovieListViewModel(movieService: movieService, genreService: genreService, ioScheduler: scheduler, uiScheduler: scheduler)
        }
        
        describe("movie list view model") {
            
            context("fetch movies") {
                
                context("succeeds") {
                    
                    it("is not done") {
                        
                        expect(viewModel.isFetchingMovies) == false
                        expect(viewModel.moviesCount) == 0
                        expect(viewModel.error.value).to(beNil())
                        
                        expect(genreService.fetchCalled) == false
                        expect(movieService.upcomingCalled) == false
                        viewModel.fetchMovies()
                        expect(genreService.fetchCalled) == true
                        expect(movieService.upcomingCalled) == false
                        expect(viewModel.isFetchingMovies) == true
                        
                        genreService.fetchSuccess(factory.genres(10))
                        expect(movieService.upcomingCalled) == true
                        movieService.fetchSuccess(factory.movies(20))
                        
                        expect(viewModel.isFetchingMovies) == false
                        expect(viewModel.moviesCount) == 20
                        expect(viewModel.isDone) == false
                        
                    }
                    
                    
                    it("is done") {
                        
                        expect(viewModel.isFetchingMovies) == false
                        expect(viewModel.moviesCount) == 0
                        expect(viewModel.error.value).to(beNil())
                        
                        viewModel.fetchMovies()
                        expect(viewModel.isFetchingMovies) == true
                        
                        genreService.fetchSuccess(factory.genres(10))
                        movieService.fetchSuccess(factory.movies(19))
                        
                        expect(viewModel.isFetchingMovies) == false
                        expect(viewModel.moviesCount) == 19
                        expect(viewModel.isDone) == true
                        
                    }
                    
                    
                }
                
                context("failure") {
                    
                    it("connection") {
                        
                        expect(viewModel.isFetchingMovies) == false
                        expect(viewModel.error.value).to(beNil())
                        
                        viewModel.fetchMovies()
                        expect(viewModel.isFetchingMovies) == true
                        
                        genreService.fetchSuccess(factory.genres(1))
                        movieService.fetchError(AppError.network)
                        
                        expect(viewModel.isFetchingMovies) == false
                        expect(viewModel.moviesCount) == 0
                        expect(viewModel.error.value).to(equal(AppError.network))
                        
                    }
                    
                    it("unknown") {
                        
                        expect(viewModel.isFetchingMovies) == false
                        expect(viewModel.error.value).to(beNil())
                        
                        viewModel.fetchMovies()
                        expect(viewModel.isFetchingMovies) == true
                        
                        genreService.fetchSuccess(factory.genres(1))
                        movieService.fetchError(AppError.unknown)
                        
                        expect(viewModel.isFetchingMovies) == false
                        expect(viewModel.moviesCount) == 0
                        expect(viewModel.error.value).to(equal(AppError.unknown))
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
}

