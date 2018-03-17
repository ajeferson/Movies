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

struct MovieService: MovieServiceProtocol {
    
    func imageUrl(for path: String, with size: Sizeable) -> String {
        return "\(Urls.imagePath.rawValue)/\(size.size)\(path)"
    }
    
    
    func fetchMovies(atPath path: MoviePath, onPage page: Int, withParams params: Parameters = [:]) -> Single<[Movie]> {
        
        // Assembling custom parameters
        var parameters = Parameters()
        params.forEach { parameters[$0] = $1 }
        
        parameters["api_key"] = Auth.apiKey.rawValue
        parameters["page"] = page
        parameters["language"] = "en-US" // TODO
        
        return Single.create { single -> Disposable in
            
            let request = Alamofire.request(path.fullUrl,
                              method: .get,
                              parameters: parameters,
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
            
            return Disposables.create { request.cancel() }
            
        }
        
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
