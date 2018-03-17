//
//  MovieListCollectionViewCell.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell, Identifiable {
    
    static var identifier: String = "MovieListCollectionViewCell"
    
    @IBOutlet weak var labelTitle: UILabel!
    
    var viewModel: MovieListViewModel.MovieListCellViewModel? {
        didSet {
            labelTitle.text = viewModel?.title
        }
    }
    
}
