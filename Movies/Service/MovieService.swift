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

struct MovieService: BaseServiceProtocol, MovieServiceProtocol {
    
    typealias Model = MovieResults
    
    func imageUrl(for path: String, with size: Sizeable) -> String {
        return "\(Urls.imagePath.rawValue)/\(size.size)\(path)"
    }
    
    
    func fetchMovies(atPath path: MoviePath, onPage page: Int, withParams params: Parameters = [:]) -> Single<[Movie]> {
        
        var parameters = Parameters()
        params.forEach { parameters[$0] = $1 }
        parameters["page"] = page
        
        return fetchModel(url: path.fullUrl, withParams: parameters)
            .map { $0.results ?? [Movie]() }
        
    }
    
    func upcomingMovies(at page: Int) -> Single<[Movie]> {
        return fetchMovies(atPath: .upcoming, onPage: page)
    }
    
    func searchMovies(with query: String, at page: Int) -> Single<[Movie]> {
        return fetchMovies(atPath: .search, onPage: page, withParams: ["query": query])
    }
    
    func fetchImage(of size: Sizeable, at path: String) -> Single<Data> {
        
        return Single.create { [url = imageUrl(for: path, with: size) ] single in
            
            Alamofire
                .request(url)
                .validate()
                .responseData { (response) in
                    
                    if let data = response.result.value {
                        single(.success(data))
                    } else {
                        single(.error(response.isNetworkError ? AppError.network : AppError.unknown))
                    }
                    
            }
            
            return Disposables.create()
            
        }
        
    }
    
}
