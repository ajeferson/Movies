//
//  ImageService.swift
//  Movies
//
//  Created by Alan Jeferson on 18/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol ImageServiceProtocol {
    
    func fetchImage(of size: Sizeable, at path: String) -> Single<Data>
    
}

struct ImageService: ImageServiceProtocol {
    
    func imageUrl(for path: String, with size: Sizeable) -> String {
        return "\(Urls.imagePath.rawValue)/\(size.size)\(path)"
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
