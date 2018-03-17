//
//  MovieListCellViewModel.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift

class MovieListCellViewModel {
    
    let title: String
    let releaseDateStr: String
    let posterPath: String?
    let backdropPath: String?
    let genres: [Genre]
    
    let movieService: MovieServiceProtocol
    
    let disposeBag = DisposeBag()
    
    // Expose to the View, so it knows about the image fetching
    let isLoading = Variable(false)
    let posterImage: Variable<UIImage?> = Variable(nil)
    
    let ioScheduler: Scheduler
    let uiScheduler: Scheduler
    
    init(movie: Movie, genres: [Genre]?, movieService: MovieServiceProtocol, ioScheduler: Scheduler = Schedulers.io, uiScheduler: Scheduler = Schedulers.main) {
        title = movie.title
        releaseDateStr = movie.releaseDateStr
        posterPath = movie.posterPath
        backdropPath = movie.backdropPath
        self.genres = genres ?? [Genre]()
        self.movieService = movieService
        self.ioScheduler = ioScheduler
        self.uiScheduler = uiScheduler
    }
    
    func fetchImage() {
        
        // Check if there the movie actually has an image
        guard let path = posterPath else {
            return
        }
        
        // Will fetch
        isLoading.value = true
        
        movieService
            .fetchImage(of: PosterSize.w500, at: path)
            .subscribeOn(ioScheduler)
            .observeOn(uiScheduler)
            .subscribe(onSuccess: { [weak self] data in
                
                self?.isLoading.value = false
                self?.posterImage.value = UIImage(data: data)
                
            }) { [weak self] error in
                
                self?.isLoading.value = false
                
            }
            .disposed(by: disposeBag)
        
    }
    
}

