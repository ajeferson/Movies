//
//  AppError.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation

enum AppError: String, Error {
 
    case network = "Verifique sua conexão com a internet"
    case unknown = "Ocorreu um erro, tente novamente mais tarde"
    case decode = "Não possível parsear os dados"
    
}
