//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift

class MovieDetailViewModel {
    
    private let movie: Movie
    private let genres: [Genre]
    
    let imageService: ImageServiceProtocol
    
    let backdrop: Variable<UIImage?> = Variable(nil)
    let poster: Variable<UIImage?> = Variable(nil)
    
    let ioScheduler: Scheduler
    let uiScheduler: Scheduler
    
    let disposeBag = DisposeBag()
    
    // Expose to the view
    let title: String
    let overview: String
    var releaseDateStr: String?
    
    var genresString: String {
        let str = genres.map { $0.name }.joined(separator: ", ")
        return str.isEmpty ? "" :  "Genre(s): \(str)"
    }
    
    
    init(movie: Movie, genres: [Genre]?, imageService: ImageServiceProtocol, ioScheduler: Scheduler = Schedulers.io, uiScheduler: Scheduler = Schedulers.main) {
        self.movie = movie
        self.genres = genres ?? [Genre]()
        if let date = movie.releaseDate {
            releaseDateStr = DateFormatter.default.string(from: date)
        }
        
        self.imageService = imageService
        
        self.ioScheduler = ioScheduler
        self.uiScheduler = uiScheduler
        
        // Movie attributes
        title = movie.title
        overview = movie.overview
        
    }
    
    func fetchImages() {
        
        // Movie does not have a backdrop
        guard let path = movie.backdropPath else { return }
        fetchImage(of: BackdropSize.w780, at: path, onSuccess: { [weak self] in self?.backdrop.value = $0 }, onError: { _ in })

        // Movie does not have a backdrop
        guard let posterPath = movie.posterPath else { return }
        fetchImage(of: PosterSize.w500, at: posterPath, onSuccess: { [weak self] in self?.poster.value = $0 }, onError: { _ in })
        
    }
    
    private func fetchImage(of size: Sizeable, at path: String, onSuccess: @escaping (UIImage?) -> Void, onError: @escaping ((Error) -> Void)) {
        imageService
            .fetchImage(of: size, at: path)
            .asObservable()
            .map { UIImage(data: $0) }
            .subscribeOn(ioScheduler)
            .observeOn(uiScheduler)
            .subscribe(onNext: { image in
                onSuccess(image)
            }, onError: { error in
                onError(error)
            })
            .disposed(by: disposeBag)
    }
    
}
