//
//  MovieListViewController.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieListViewController: BaseViewController, Identifiable {
    
    static var identifier: String = "MovieListViewController"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    var viewModel: MovieListViewModel!
    
    static func newInstance(viewModel: MovieListViewModel) -> MovieListViewController {
        let instance = storyboard.instantiateViewController(withIdentifier: MovieListViewController.identifier) as! MovieListViewController
        instance.viewModel = viewModel
        return instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        viewModel.fetchMovies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Bind view model attributes to UI controls and make subscriptions
    private func subscribe() {
        subscribeToIsLoading()
        bindViewModelCellsToCollectionView()
    }
    
    private func subscribeToIsLoading() {
        viewModel
            .isLoading
            .asObservable()
            .subscribe(onNext: { [weak self] isLoading in
                self?.loadingStateChange(to: isLoading)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelCellsToCollectionView() {
        viewModel
            .viewModelCells
            .asObservable()
            .bind(to: collectionView
                .rx
                .items(cellIdentifier: MovieListCollectionViewCell.identifier,
                       cellType: MovieListCollectionViewCell.self)) {
                        row, cellViewModel, cell in
                        cell.viewModel = cellViewModel
            }
            .disposed(by: disposeBag)
    }
    
    private func loadingStateChange(to isLoading: Bool) {
        activityIndicator.isVisible = isLoading
        collectionView.isHidden = isLoading
    }
    
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
