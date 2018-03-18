//
//  Connectivity.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import Alamofire

struct Connectivity {
    
    static var isConnected: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
}
