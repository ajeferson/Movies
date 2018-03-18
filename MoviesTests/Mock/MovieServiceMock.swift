//
//  MovieServiceMock.swift
//  MoviesTests
//
//  Created by Alan Jeferson on 18/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift

@testable import Movies

class MovieServiceMock: MovieServiceProtocol {
    
    let subject = PublishSubject<[Movie]>()
    var upcomingCalled = false
    var searchCalled = false
    
    func upcomingMovies(at page: Int) -> Single<[Movie]> {
        upcomingCalled = true
        return subject.asSingle()
    }
    
    func fetchSuccess(_ movies: [Movie]) {
        subject.onNext(movies)
        subject.onCompleted()
    }
    
    func fetchError(_ error: AppError) {
        subject.onError(error)
    }
    
    func searchMovies(with query: String, at page: Int) -> Single<[Movie]> {
        searchCalled = true
        return subject.asSingle()
    }
    
}
