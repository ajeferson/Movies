//
//  SearchResultsViewModel.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift

class SearchResultsViewModel {
    
    let movieService: MovieServiceProtocol
    
    let ioScheduler: Scheduler
    let uiScheduler: Scheduler
    
    var movies = [Movie]()
    
    var currentQuery = ""
    
    var currentPage = 1
    var pageSize = 20
    
    var isLoading: Variable<Bool?> = Variable(nil)
    var error: Variable<AppError?> = Variable(nil)
    
    var emptyResults = Variable(false)
    var viewModelCells: Variable<[SearchResultsCellViewModel]> = Variable([])
    
    var disposeBag = DisposeBag()
    
    var isSearching: Bool {
        return isLoading.value ?? false
    }
    
    var resultsCount: Int {
        return viewModelCells.value.count
    }
    
    var isDone = false
    
    init(movieService: MovieServiceProtocol, ioScheduler: Scheduler = Schedulers.io, uiScheduler: Scheduler = Schedulers.main) {
        self.movieService = movieService
        self.ioScheduler = ioScheduler
        self.uiScheduler = uiScheduler
    }
    
    func search(query: String? = nil, fromFirstPage reset: Bool) {
        
        let searchQuery = query ?? currentQuery
        currentQuery = searchQuery
        
        if reset { clearSearch() }
        
        // Show loader if fetch from first page
        isLoading.value = reset
        
        movieService
            .searchMovies(with: searchQuery, at: currentPage)
            .subscribeOn(ioScheduler)
            .observeOn(uiScheduler)
            .subscribe(onSuccess: { [weak self] movies in
                
                self?.isLoading.value = false
                self?.process(movies: movies)
                
            }) { [weak self] error in
                
                self?.isLoading.value = false
                self?.error.value = error as? AppError
                
            }
            .disposed(by: disposeBag)
        
    }
    
    func clearSearch() {
        self.movies.removeAll(keepingCapacity: true)
        viewModelCells.value.removeAll(keepingCapacity: true)
        emptyResults.value = false
        isLoading.value = false
        currentPage = 1
        disposeBag = DisposeBag() // Dispose previous request (i.e. cancel them)
    }
    
    func process(movies: [Movie]) {
        emptyResults.value = movies.isEmpty && currentPage == 1
        currentPage += 1
        isDone = movies.count < pageSize
        self.movies.append(contentsOf: movies)
        viewModelCells.value.append(contentsOf: movies.map { SearchResultsCellViewModel(movie: $0) })
    }
    
    func movie(at index: Int) -> Movie {
        return movies[index]
    }
    
}
