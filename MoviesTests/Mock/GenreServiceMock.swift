//
//  GenreServiceMock.swift
//  MoviesTests
//
//  Created by Alan Jeferson on 18/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift

@testable import Movies

class GenreServiceMock: GenreServiceProtocol {

    let subject = PublishSubject<[Genre]>()
    var fetchCalled = false
    
    func fetchGenres() -> Single<[Genre]> {
        fetchCalled = true
        return subject.asSingle()
    }
    
    func fetchSuccess(_ genres: [Genre]) {
        subject.onNext(genres)
        subject.onCompleted()
    }
    
    func fetchError(_ error: AppError) {
        subject.onError(error)
    }
    
    func genresOf(movie: Movie) -> [Genre]? {
        return nil
    }
    
}

