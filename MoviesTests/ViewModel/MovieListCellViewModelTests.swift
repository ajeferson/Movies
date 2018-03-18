//
//  MovieListCellViewModelTests.swift
//  MoviesTests
//
//  Created by Alan Jeferson on 18/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Movies


class MovieListCellViewModelTests: QuickSpec {
    
    override func spec() {
        
        
        let factory = StubFactory()
        var movie: Movie!
        var imageService: ImageServiceMock!
        var viewModel: MovieListCellViewModel!
        let scheduler = Schedulers.current
        
        beforeEach {
            movie = factory.movies(1).first
            imageService = ImageServiceMock()
            viewModel = MovieListCellViewModel(movie: movie, genres: nil, imageService: imageService, ioScheduler: scheduler, uiScheduler: scheduler)
        }
        
        describe("movie list cell view model ") {
            
            it("presentation") {
               expect(viewModel.title).to(equal(movie.title))
                expect(viewModel.posterPath).to(equal(movie.posterPath))
                let date = DateFormatter.default.date(from: viewModel.releaseDateStr!)
                expect(date).notTo(beNil()) // Means that the date is in human readable format
            }
            
            context("fetchImage") {
                
                context("success") {
                    
                    it("without poster") {
                        movie.posterPath = nil
                        viewModel = MovieListCellViewModel(movie: movie, genres: nil, imageService: imageService, ioScheduler: scheduler, uiScheduler: scheduler)
                        viewModel.fetchImage()
                        expect(imageService.fetchImageCalled) == false
                        expect(viewModel.isLoading.value) == false
                    }
                    
                    it("with poster") {
                        
                        expect(imageService.fetchImageCalled) == false
                        expect(viewModel.isLoading.value) == false
                        
                        viewModel.fetchImage()
                        
                        expect(viewModel.isLoading.value) == true
                        expect(imageService.fetchImageCalled) == true
                        
                        imageService.fetchSuccess(Data())
                        
                        expect(viewModel.isLoading.value) == false
                    }
                    
                }
                
                it("fails") {
                    
                    expect(imageService.fetchImageCalled) == false
                    expect(viewModel.isLoading.value) == false
                    expect(viewModel.error.value).to(beNil())
                    
                    viewModel.fetchImage()
                    
                    expect(viewModel.isLoading.value) == true
                    expect(imageService.fetchImageCalled) == true
                    
                    imageService.fetchError(AppError.network)
                    
                    expect(viewModel.isLoading.value) == false
                    expect(viewModel.error.value).to(equal(AppError.network))
                    
                }
                
            }
            
        }
        
    }
    
}
