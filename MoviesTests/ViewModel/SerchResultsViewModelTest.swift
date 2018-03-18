//
//  SerchResultsViewModelTest.swift
//  MoviesTests
//
//  Created by Alan Jeferson on 18/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Movies

class SearchResultsViewModelTests: QuickSpec {
    
    override func spec() {
        
        let factory = StubFactory()
        var movieService: MovieServiceMock!
        let scheduler = Schedulers.current
        var viewModel: SearchResultsViewModel!
        
        beforeEach {
            movieService = MovieServiceMock()
            viewModel = SearchResultsViewModel(movieService: movieService, ioScheduler: scheduler, uiScheduler: scheduler)
        }
        
        describe("search results view model") {
            
            context("search") {
                
                it("success") {
                    
                    expect(viewModel.resultsCount) == 0
                    expect(viewModel.isSearching) == false
                    expect(movieService.searchCalled) == false
                    
                    viewModel.currentPage = 2
                    
                    viewModel.search(query: "", fromFirstPage: true)
                    expect(viewModel.currentPage) == 1
                    expect(viewModel.isSearching) == true
                    expect(movieService.searchCalled) == true
                    
                    movieService.fetchSuccess(factory.movies(10))
                    expect(viewModel.isSearching) == false
                    expect(viewModel.resultsCount) == 10
                    
                }
                
                it("fails") {
                    
                    expect(viewModel.resultsCount) == 0
                    expect(viewModel.isSearching) == false
                    expect(viewModel.error.value).to(beNil())
                    expect(movieService.searchCalled) == false
                    
                    viewModel.search(query: "", fromFirstPage: true)
                    expect(movieService.searchCalled) == true
                    
                    movieService.fetchError(AppError.network)
                    expect(viewModel.isSearching) == false
                    expect(viewModel.error.value).notTo(beNil())
                    expect(viewModel.resultsCount) == 0
                    
                }
                
            }
            
            it("clear search") {
               
                expect(viewModel.resultsCount) == 0
                expect(viewModel.isSearching) == false
                expect(movieService.searchCalled) == false
                
                viewModel.currentPage = 2
                
                viewModel.search(query: "", fromFirstPage: true)
                expect(viewModel.currentPage) == 1
                expect(viewModel.isSearching) == true
                expect(movieService.searchCalled) == true
                
                movieService.fetchSuccess(factory.movies(10))
                expect(viewModel.currentPage) == 2
                expect(viewModel.isSearching) == false
                expect(viewModel.resultsCount) == 10
                
                viewModel.clearSearch()
                expect(viewModel.resultsCount) == 0
                expect(viewModel.currentPage) == 1
                
            }
            
        }
        
    }
    
}
