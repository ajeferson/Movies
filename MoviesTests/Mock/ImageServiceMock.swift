//
//  ImageServiceMock.swift
//  MoviesTests
//
//  Created by Alan Jeferson on 18/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift

@testable import Movies

class ImageServiceMock: ImageServiceProtocol {
    
    let subject = PublishSubject<Data>()
    var fetchImageCalled = false
    
    func fetchImage(of size: Sizeable, at path: String) -> Single<Data> {
        fetchImageCalled = true
        return subject.asSingle()
    }
    
    func fetchSuccess(_ data: Data) {
        subject.onNext(data)
        subject.onCompleted()
    }
    
    func fetchError(_ error: AppError) {
        subject.onError(error)
    }
    
}
