//
//  DataResponseExtension.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import Alamofire

extension DataResponse {
    
    var isSuccess: Bool {
        return self.response?.statusCode == 200
    }
    
    var isCreated: Bool {
        return self.response?.statusCode == 201
    }
    
    var isNotFound: Bool {
        return self.response?.statusCode == 404
    }
    
    var isUnauthorized: Bool {
        return self.response?.statusCode == 401
    }
    
    var isServerError: Bool {
        return self.response?.statusCode == 500
    }
    
    var isNetworkError: Bool {
        return self.response == nil
    }
    
}
