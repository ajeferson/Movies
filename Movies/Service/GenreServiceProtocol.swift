//
//  GenreServiceProtocol.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift

protocol GenreServiceProtocol {
    func fetchGenres() -> Single<[Genre]>
    func genresOf(movie: Movie) -> [Genre]?
}
