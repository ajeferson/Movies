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
    let genreService: GenreService
    
    let ioScheduler: Scheduler
    let uiScheduler: Scheduler
    
    var disposeBag = DisposeBag()
    var isLoading = Variable(false)
    
    var currentPage = 1
    let pageSize = 20
    
    var movies = [Movie]()
    var viewModelCells: Variable<[MovieListCellViewModel]> = Variable([])
    
    var moviesCount: Int {
        return viewModelCells.value.count
    }
    
    var isFetchingMovies: Bool {
        return isLoading.value
    }
    
    var isDone = false
    
    init(movieService: MovieServiceProtocol, genreService: GenreService, ioScheduler: Scheduler = Schedulers.io, uiScheduler: Scheduler = Schedulers.main) {
        self.movieService = movieService
        self.genreService = genreService
        self.ioScheduler = ioScheduler
        self.uiScheduler = uiScheduler
    }
    
    func fetchMovies() {
        
        isLoading.value = viewModelCells.value.isEmpty
        
        genreService
            .fetchGenres()
            .flatMap { [movieService, currentPage] _ in movieService.upcomingMovies(at: currentPage) }
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
    
    // ViewModel creates ViewModel
    func getMovieDetailViewModel(at index: Int) -> MovieDetailViewModel {
        return MovieDetailViewModel(movie: movies[index], genres: genresOf(movie: movies[index]), movieService: movieService)
    }
    
    func getMoviewDetailViewModel(`for` movie: Movie) -> MovieDetailViewModel {
        return MovieDetailViewModel(movie: movie, genres: genresOf(movie: movie), movieService: movieService)
    }
    
    func getSearchResultsViewModel() -> SearchResultsViewModel {
        return SearchResultsViewModel(movieService: movieService)
    }
    
    private func genresOf(movie: Movie) -> [Genre]? {
        return genreService.genresOf(movie: movie)
    }
    
    private func process(movies: [Movie]) {
        currentPage += 1
        isDone = movies.count < pageSize
        self.movies.append(contentsOf: movies)
        
        let cells = movies.map { [weak self] movie -> MovieListCellViewModel in
            return MovieListCellViewModel(movie: movie, genres: self?.genresOf(movie: movie), movieService: movieService)
        }
        
        viewModelCells.value.append(contentsOf: cells)
        
    }
    
}
