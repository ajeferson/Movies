//
//  PosterSize.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation

protocol Sizeable {
    var size: String { get }
}

enum PosterSize: String, Sizeable {
    
    case w92, w154, w185, w342, w500, w780, original
    
    var size: String {
        return rawValue
    }
    
}

enum BackdropSize: String, Sizeable {
    
    case w300, w780, w1280, original
    
    var size: String {
        return rawValue
    }
    
}
