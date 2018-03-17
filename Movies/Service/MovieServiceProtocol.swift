//
//  MovieServiceProtocol.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift

protocol MovieServiceProtocol {
    
    func upcomingMovies(at page: Int) -> Single<[Movie]>
    
    func fetchImage(of size: Sizeable, at path: String) -> Single<Data>
    
}
