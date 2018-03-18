//
//  BaseService.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol BaseServiceProtocol {
    associatedtype Model: Codable
}

extension BaseServiceProtocol {
    
    func fetchModel(url: String, withParams params: Parameters = [:]) -> Single<Model> {
        
        // Assembling custom parameters
        var parameters = Parameters()
        params.forEach { parameters[$0] = $1 }
        parameters["api_key"] = Auth.apiKey.rawValue
        parameters["language"] = "en-US"
        
        return Single<Model>.create { [url] single in
            
            let request = Alamofire
                .request(url,
                         method: .get,
                         parameters: parameters,
                         encoding: URLEncoding.default,
                         headers: nil)
                .responseData(completionHandler: { response in
                    
                    switch response.result {
                    case .success(let value):
                        
                        let decoder = JSONDecoder()
                        do {
                            let results = try decoder.decode(Model.self, from: value)
                            single(.success(results))
                        } catch {
                            single(.error(AppError.unknown))
                        }
                        
                    case .failure:
                        single(.error(response.isNetworkError ? AppError.network : AppError.unknown))
                    }
                    
                })
            
            return Disposables.create { request.cancel() }
        }
        
    }
    
}
