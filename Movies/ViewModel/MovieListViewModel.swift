//
//  MovieListViewModel.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift

class MovieListViewModel {
    
    let movieService: MovieServiceProtocol
    
    let ioScheduler: ImmediateSchedulerType
    let uiScheduler: ImmediateSchedulerType
    
    var disposeBag = DisposeBag()
    var isLoading = Variable(false)
    
    var currentPage = 1
    var viewModelCells: Variable<[MovieListCellViewModel]> = Variable([])
    
    init(movieService: MovieServiceProtocol, ioScheduler: ImmediateSchedulerType = Schedulers.io, uiScheduler: ImmediateSchedulerType = Schedulers.main) {
        self.movieService = movieService
        self.ioScheduler = ioScheduler
        self.uiScheduler = uiScheduler
    }
    
    func fetchMovies() {
        
        isLoading.value = true
        
        movieService
            .upcomingMovies(at: currentPage)
            .subscribeOn(ioScheduler)
            .observeOn(uiScheduler)
            .subscribe(onSuccess: { [weak self] movies in
                self?.isLoading.value = false
                self?.process(movies: movies)
            }) { [weak self] error in
                self?.isLoading.value = false
            }
            .disposed(by: disposeBag)
        
    }
    
    private func process(movies: [Movie]) {
        viewModelCells.value = movies.map { MovieListCellViewModel(movie: $0) }
    }
    
    struct MovieListCellViewModel {
        
        let title: String
        let releaseDateStr: String
        let posterPath: String?
        let backdropPath: String?
        
        init(movie: Movie) {
            title = movie.title
            releaseDateStr = movie.releaseDateStr
            posterPath = movie.posterPath
            backdropPath = movie.backdropPath
        }
        
    }
    
    
}
