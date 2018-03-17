//
//  MovieListCollectionViewCell.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit
import RxSwift

class MovieListCollectionViewCell: UICollectionViewCell, Identifiable {
    
    static var identifier: String = "MovieListCollectionViewCell"
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    
    var viewModel: MovieListCellViewModel? {
        didSet {
            labelTitle.text = viewModel?.title
            disposeBag = DisposeBag() // Dispose previous disposables
            bindToIsLoading()
            subscribeToPosterImgit age()
        }
    }
    
    private func bindToIsLoading() {
        viewModel?
            .isLoading
            .asObservable()
            .map { !$0 }
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func subscribeToPosterImage() {
        viewModel?
            .posterImage
            .asObservable()
            .subscribe(onNext: { [weak self] image in
                self?.imageViewPoster.image = image
            })
            .disposed(by: disposeBag)
    }
    
}
