//
//  Urls.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation

enum AppError: String, Error {
    
    case network = "Check your internet connection"
    case unknown = "An error has occurred, please try again later"
    
}

enum Urls: String {
    case basePath = "https://api.themoviedb.org/3"
    case imagePath = "https://image.tmdb.org/t/p"
}

enum Auth: String {
    case apiKey = "1f54bd990f1cdfb230adb312546d765d"
}

enum MoviePath: String {
    
    case upcoming = "/movie/upcoming"
    case search = "/search/movie"
    
    var fullUrl: String {
        return "\(Urls.basePath.rawValue)\(rawValue)"
    }
    
}

enum GenrePath: String {
    
    case movie = "/genre/movie/list"
    
    var fullUrl: String {
        return "\(Urls.basePath.rawValue)\(rawValue)"
    }
    
}

protocol Sizeable{
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

