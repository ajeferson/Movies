//
//  MovieService.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class MovieService: MovieServiceProtocol {
    
    let basePath = "https://api.themoviedb.org/3"
    let imagePath = "http://image.tmdb.org/t/p"
    let apiKey = "1f54bd990f1cdfb230adb312546d765d"
    
    lazy var upcomingMoviesUrl: String = {
        return "\(basePath)/movie/upcoming"
    }()
    
    
    func upcomingMovies(at page: Int) -> Single<[Movie]> {
       
        if !Connectivity.isConnected {
            return Single.error(AppError.network)
        }
        
        // TODO Language
        // TODO page
        
        let params: Parameters = [
            "api_key": apiKey,
            "page": page,
            "language": "en"
        ]
        
        return Single.create(subscribe: { [url = upcomingMoviesUrl] single -> Disposable in
            
            Alamofire.request(url,
                              method: .get,
                              parameters: params,
                              encoding: URLEncoding.default,
                              headers: nil)
                .responseData(completionHandler: { response in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        guard let movies = Movie.from(data: value) else {
                            single(.error(AppError.decode))
                            return
                        }
                        
                        single(.success(movies))
                        
                    case .failure:
                        single(.error(response.isNetworkError ? AppError.network : AppError.unknown))
                        
                    }
                    
                })
            
            return Disposables.create()
            
        })
        
    }
    
}
