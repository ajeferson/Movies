//
//  GenreService.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol GenreServiceProtocol {
    func fetchGenres() -> Single<[Genre]>
    func genresOf(movie: Movie) -> [Genre]?
}

class GenreService: BaseServiceProtocol, GenreServiceProtocol {
    
    typealias Model = GenreResults
    
    static let shared = GenreService()
    
    private var genres: [Genre]?
    
    func fetchGenres() -> Single<[Genre]> {
        
        // Use the `cache`
        if let genres = genres {
            return Single.just(genres)
        }
        
        return fetchModel(url: GenrePath.movie.fullUrl)
            .do(onSuccess: { [weak self] value in
                self?.genres = value.genres // Caching genres
        }).map { $0.genres
            
        }
        
    }
    
    func genresOf(movie: Movie) -> [Genre]? {
        return genres?.filter { movie.genreIds.contains($0.id) }
    }
    
}
